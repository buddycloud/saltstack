install-buddyclould-http-api-dependencies:
  pkg.installed:
    - pkgs:
      - git
      - git-core
      - libicu-dev
      - libexpat-dev
      - build-essential
      - libexpat1-dev
      - libssl-dev
      - build-essential
      - g++

buddycloud-http-api-git-checkout:
  git.latest:
    - name: https://github.com/buddycloud/buddycloud-http-api.git
    - rev: {{ salt['pillar.get']('buddycloud:lookup:git-branch') }}
    - target: /opt/buddycloud-http-api
    - force_reset: true
    - force: true

/opt/buddycloud-http-api:
  file.directory:
    - user: buddycloud
    - group: buddycloud
    - mode: 755
    - recurse:
      - user
      - group

/var/log/buddycloud/buddycloud-http-api.log:
  file.managed:
    - user: buddycloud
    - group: buddycloud
    - mode: 644

buddycloud-http-api-install:
  cmd.run:
    - name: npm i --development .
    - cwd: /opt/buddycloud-http-api
    - runas: buddycloud
    - env: 
      - HOME: /opt/buddycloud-http-api
    - require:
      - pkg: install-buddyclould-http-api-dependencies

/opt/buddycloud-http-api/config.js:
  file.managed:
    - source: salt://buddycloud-http-api/config.js.template
    - template: jinja

/etc/logrotate.d/buddycloud-http-api:
  file.managed:
    - source: salt://buddycloud-http-api/logrotate
    - user: root
    - group: root

/etc/init/buddycloud-http-api.conf:
  file.managed:
    - source: salt://buddycloud-http-api/upstart-script
    - user: root
    - group: root
    - mode: 0755

buddycloud-http-api:
  service.running:
    - name: buddycloud-http-api
    - enable: True
    - force_reload: True
    - full_restart: True
    - require:
      - cmd: buddycloud-http-api-install
      - file: /etc/init/buddycloud-http-api.conf
      - file: /etc/logrotate.d/buddycloud-http-api
      - file: /etc/init/buddycloud-http-api.conf
      - file: /var/log/buddycloud/buddycloud-http-api.log
      - pkg: install-buddyclould-http-api-dependencies
    - watch:
      - file: /opt/buddycloud-http-api/*
      - file: /etc/init/buddycloud-http-api.conf
