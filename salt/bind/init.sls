/etc/bind/named.conf.options:
  file.managed:
    - source: salt://bind/named.conf.options.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

/etc/bind/named.conf.local:
  file.managed:
    - source: salt://bind/named.conf.local.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

/var/lib/bind/db.buddycloud.jnl:
  file.absent

/var/lib/bind/db.buddycloud:
  file.managed:
    - source: salt://bind/db.buddycloud.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

bind-server:
  pkg.installed:
    - name: bind9
  service.running:
    - name: bind9
    - enable: True
    - reload: True
    - require:
      - pkg: bind9
    - watch:
      - file: /var/lib/bind/db.buddycloud
      - file: /etc/bind/named.conf.local
      - file: /etc/bind/named.conf.options

/etc/dhcp/dhclient.conf:
  file.append:
    - text: "supersede domain-name-servers 127.0.0.1;"

re-dhcp:
  cmd.run:
    - name: ifup -a --force
    - name: resolvconf -u

bind-firewall-53-udp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 53
    - proto: udp
    - save: True

bind-firewall-53-tcp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 53
    - proto: tcp
    - save: True
