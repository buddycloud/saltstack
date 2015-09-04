#
# Prosody - jabber server
#

prosody-repo:
  pkgrepo.managed:
   - name: deb http://packages.prosody.im/debian trusty main
   - key_url: http://packages.prosody.im/debian/pubkey.asc
   - require_in:
     - pkg: prosody

prosody-packages:
  pkg.installed:
    - pkgs:
      - prosody-0.10
    - require:
      - pkgrepo: prosody-repo

/etc/prosody/modules:
  file.recurse:
    - source: salt://prosody/modules
    - user: root
    - group: root
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - require_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

/etc/prosody/prosody.cfg.lua:
  file.managed:
    - source: salt://prosody/prosody.cfg.lua.jinja
    - template: jinja
    - user: root
    - group: prosody
    - mode: 640
    - watch_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

prosody-read-certificates:
  user.present:
    - name: prosody
    - groups:
      - certificates

prosody:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - sig: "/usr/bin/lua5.1 /usr/bin/prosody"
    - watch:
      - file: /etc/prosody/prosody.cfg.lua
    - require:
      - pkg: prosody

prosody-firewall-c2s:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 5222
    - proto: tcp
    - save: True

prosody-firewall-s2s:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 5269
    - proto: tcp
    - save: True
