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

{% for A_record in ['channels','media','friendfinder','pusher','api','s2s','c2s','webclient','search'] %}
dns-A-record-{{A_record}}:
  ddns.present:
    - rdtype: A
    - name: {{A_record}}
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5.9.67.253
    - nameserver: 5.9.91.110
    - keyfile: {{keyfile}}
    - keyname: buddycloud.net
{% endfor %}

dns-TXT-record-API:
  ddns.present:
    - rdtype: TXT
    - name: _buddycloud-api._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: '"v=1.0 host=demo.{{ salt['pillar.get']('buddycloud:lookup:domain') }} protocol=https path=/api port={{ salt['pillar.get']('buddycloud:lookup:web-listen-port') }}"'
    - nameserver: 5.9.91.110
    - keyfile: {{keyfile}}
    - keyname: buddycloud.net

dns-TXT-record-channel-server:
  ddns.present:
    - rdtype: TXT
    - name: _bcloud-server._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: '"v=1.0 server=channels.{{ salt['pillar.get']('buddycloud:lookup:domain') }}"'
    - nameserver: 5.9.91.110
    - keyfile: {{keyfile}}
    - keyname: buddycloud.net

dns-SRV-record-c2s:
  ddns.present:
    - rdtype: SRV
    - name: _xmpp-client._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5 0 5222 c2s.{{ salt['pillar.get']('buddycloud:lookup:domain') }}.
    - nameserver: 5.9.91.110
    - keyfile: {{keyfile}}
    - keyname: buddycloud.net

dns-SRV-record-s2s:
  ddns.present:
    - rdtype: SRV
    - name: _xmpp-server._tcp
    - zone: {{ salt['pillar.get']('buddycloud:lookup:domain') }}
    - ttl: 300
    - data: 5 0 5269 s2s.{{ salt['pillar.get']('buddycloud:lookup:domain') }}.
    - nameserver: 5.9.91.110
    - keyfile: {{keyfile}}
    - keyname: buddycloud.net
