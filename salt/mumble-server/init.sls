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

mumble-read-certificates:
  user.present:
    - name: mumble-server
    - groups:
      - certificates

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

