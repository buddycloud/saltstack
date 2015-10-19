{% set pgpassword = 'postgres:users:' + salt['pillar.get']('buddycloud:lookup:env') + '_buddycloudserver:password' %}

buddycloud-server-java-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl
      - openjdk-7-jre-headless

buddycloud-server-java:
  archive.extracted:
    - name: /opt/buddycloud-server-java
    - source: https://dl.bintray.com/buddycloud/buddycloud-server-java/buddycloud-server-java.tgz
    - source_hash: https://dl.bintray.com/buddycloud/buddycloud-server-java/file.hashes
    - archive_format: tar
    - tar_options: z
    
create-buddycloud-server-schema:
  cmd.run:
    - name: cat /opt/buddycloud-server-java/postgres/*sql | psql -h {{ salt['pillar.get']('buddycloud:lookup:database-server') }} -U {{ salt['pillar.get']('buddycloud:lookup:env') }}_buddycloudserver {{ salt['pillar.get']('buddycloud:lookup:env') }}_buddycloudserver 
    - env:
      - PGPASSWORD: '{{ salt['pillar.get'](pgpassword) }}'

/opt/buddycloud-server-java/configuration.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-configuration.properties.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/opt/buddycloud-server-java/log4j.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-log4j.properties
    - user: root
    - group: root
    - mode: 0644

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
      - pkg: buddycloud-server-java-dependencies
      - cmd: create-buddycloud-server-schema
