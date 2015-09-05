install-buddyclould-channeldirectory-dependencies:
  pkg.installed:
    - pkgs:
      - java
      - git
      - git-core

buddycloud-channeldirectory-git-checkout:
  git.latest:
    - name: https://github.com/buddycloud/buddycloud-channeldirectory.git
    - rev: {{ salt['pillar.get']('buddycloud:lookup:git-branch') }}
    - target: /opt/buddycloud-channeldirectory
    - force_reset: true
    - force: true

build-buddycloud-channeldirectory:
  cmd.run:
    - javac #something 

/opt/buddycloud-channeldirectory:
  file.directory:
    - user: buddycloud
    - group: buddycloud
    - mode: 755
    - recurse:
      - user
      - group

/var/log/buddycloud/buddycloud-channeldirectory.log:
  file.managed:
    - user: buddycloud
    - group: buddycloud
    - mode: 644

/opt/buddycloud-channeldirectory/configuration.properties:
  file.managed:
    - source: salt://buddycloud-channeldirectory/configuration.properties.template
    - template: jinja

/opt/buddycloud-channeldirectory/log4j.properties:
  file.managed:
    - source: salt://buddycloud-channeldirectory/log4j.properties.template
    - template: jinja

/etc/logrotate.d/buddycloud-channeldirectory:
  file.managed:
    - source: salt://buddycloud-channeldirectory/logrotate
    - user: root
    - group: root

/etc/init/buddycloud-solr.conf:
  file.managed:
    - source: salt://buddycloud-channeldirectory/solr.upstart-script
    - user: root
    - group: root
    - mode: 0755

/etc/init/buddycloud-search.conf:
  file.managed:
    - source: salt://buddycloud-channeldirectory/search.upstart-script
    - user: root
    - group: root
    - mode: 0755

/etc/init/buddycloud-crawler.conf:
  file.managed:
    - source: salt://buddycloud-channeldirectory/crawler.upstart-script
    - user: root
    - group: root
    - mode: 0755

buddycloud-channeldirectory:
  service.running:
    - name: buddycloud-channeldirectory
    - enable: True
    - force_reload: True
    - full_restart: True
    - require:
      - cmd: buddycloud-channeldirectory-install
      - file: /etc/init/buddycloud-channeldirectory.conf
      - file: /etc/logrotate.d/buddycloud-channeldirectory
      - file: /etc/init/buddycloud-channeldirectory.conf
      - file: /var/log/buddycloud/buddycloud-channeldirectory.log
      - pkg: install-buddyclould-http-api-dependencies
    - watch:
      - file: /opt/buddycloud-channeldirectory/
      - file: /etc/init/buddycloud-crawler.conf

xmpp-ftw-firewall:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 3000
    - proto: tcp
    - save: True

