{% set myip = salt['grains.get']('ipv4')[0] %}
{% set keyfile = '/etc/ddns-keys/' + salt['pillar.get']('buddycloud:lookup:domain') + '.tsig.key' %}

python-dnspython:
  pkg.installed

# The keyring file needs to be in json format and the key name needs to end with an extra period in the file, similar to this:
# {"keyname.": "keycontent"}
{{keyfile}}:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - template: jinja
    - source: salt://buddycloud-ddns/keyfile-template.jinja

# A-Records
{% for dns_record in ['buddycloud','media','api','s2s','c2s','webclient'] %}
dns-A-record-{{dns_record}}:
  ddns.present:
    - rdtype: A
    - name: {{dns_record}}
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: {{ salt['pillar.get']('buddycloud:lookup:server-ip') }}
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}.
{% endfor %}

# XMPP components
{% for dns_record in ['channels','topics','media','friendfinder','pusher','search'] %}
dns-A-record-for-xmpp-component-{{dns_record}}:
  ddns.present:
    - rdtype: A
    - name: {{dns_record}}
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: {{ salt['pillar.get']('buddycloud:lookup:server-ip') }}
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}.

dns-SRV-record-for-xmpp-component-{{dns_record}}:
  ddns.present:
    - rdtype: SRV
    - name: _xmpp-server._tcp.{{dns_record}}
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5 0 5269 s2s.{{ salt['pillar.get']('buddycloud:lookup:domain') }}.
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
{% endfor %}

dns-TXT-record-API:
  ddns.present:
    - rdtype: TXT
    - name: _buddycloud-api._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: '"v=1.0 host={{ salt['pillar.get']('buddycloud:lookup:domain') }} protocol=https path=/api port={{ salt['pillar.get']('buddycloud:lookup:web-listen-port') }}"'
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}

dns-TXT-record-channel-server:
  ddns.present:
    - rdtype: TXT
    - name: _bcloud-server._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: '"v=1.0 server=channels.{{ salt['pillar.get']('buddycloud:lookup:domain') }}"'
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}

dns-SRV-record-c2s:
  ddns.present:
    - rdtype: SRV
    - name: _xmpp-client._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5 0 5222 c2s.{{ salt['pillar.get']('buddycloud:lookup:domain') }}.
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}

dns-SRV-record-s2s:
  ddns.present:
    - rdtype: SRV
    - name: _xmpp-server._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5 0 5269 s2s.{{ salt['pillar.get']('buddycloud:lookup:domain') }}.
    - nameserver: {{ salt['pillar.get']('buddycloud:lookup:ddns-server') }}
    - keyfile: {{keyfile}}
    - keyname: {{ salt['pillar.get']('buddycloud:lookup:domain') }}

