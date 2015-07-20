buddycloud-server-java-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl
      - openjdk-7-jre-headless

buddycloud-server-java:
  pkg:
    - installed
    - sources:
      - buddycloud-server-java: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_latest.deb

create-buddycloud-server-schema:
  cmd.run:
    - name: psql -h {{ salt['pillar.get']('buddycloud:lookup:database-server') }} -U {{ salt['pillar.get']('buddycloud:lookup:env') }}_buddycloudserver {{ salt['pillar.get']('buddycloud:lookup:env') }}_buddycloudserver -f /usr/share/dbconfig-common/data/buddycloud-server-java/install/pgsql
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('buddycloud:lookup:env') }}_{{ salt['pillar.get']('postgres:users:buddycloudserver:password') }}'

/etc/dbconfig-common/buddycloud-server-java.conf:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java.dbconfig.conf.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/usr/share/buddycloud-server-java/configuration.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-configuration.properties.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/usr/share/buddycloud-server-java/log4j.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-log4j.properties
    - user: root
    - group: root
    - mode: 0644

remove-uneeded-files:
  file.absent:
    - names:
      - /var/log/buddycloud-server-java
      - /etc/init.d/buddycloud-server-java

/etc/init/buddycloud-server-java.conf:
  file.managed:
    - source: salt://buddycloud-server-java/upstart-script
    - user: root
    - group: root
    - mode: 0755
  service.running:
    - name: buddycloud-server-java
    - enable: True
    - reload: True
    - full_restart: True
    - require:
      - pkg: buddycloud-server-java
      - pkg: buddycloud-server-java-dependencies
      - file: /usr/share/buddycloud-server-java/configuration.properties
      - file: /usr/share/buddycloud-server-java/log4j.properties
      - file: /etc/dbconfig-common/buddycloud-server-java.conf
      - file: /etc/init/buddycloud-server-java.conf
      - cmd: create-buddycloud-server-schema
