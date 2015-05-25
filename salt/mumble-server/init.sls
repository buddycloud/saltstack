mumbleserver_config:
  file.managed:
    - name: /etc/mumble-server.ini
    - source: salt://mumble-server/files/mumble-server.ini
    - template: jinja
    - user: root
    - mode: 644
    - watch_in:
      - service: mumble-server

mumbleserver:
  pkg.installed:
    - name: mumble-server
  service.running:
    - enable: True
    - name: mumble-server
    - require:
      - pkg: mumble-server

/etc/mumble/buddycloud.com.cert.pem:
  file.managed:
    - makedirs: True
    - user: mumble-server
    - group: root
    - mode: 600
    - contents_pillar: salt://ssl:buddycloud.com:cert

/etc/mumble/buddycloud.com.key.pem:
  file.managed:
    - makedirs: True
    - user: mumble-server
    - group: root
    - mode: 600
    - contents_pillar: salt://ssl:buddycloud.com:key

/etc/mumble/buddycloud.com.ca.pem:
  file.managed:
    - makedirs: True
    - user: mumble-server
    - group: root
    - mode: 600
    - contents_pillar: salt://ssl:buddycloud.com:ca

mumbleserver-tcp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 64738
    - proto: tcp
    - save: True

mumbleserver-udp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 64738
    - proto: udp
    - save: True

