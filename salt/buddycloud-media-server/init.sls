{% set pgpassword = 'postgres:users:' + salt['pillar.get']('buddycloud:lookup:env') + '_mediaserver:password' %}

media-server-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl
      - openjdk-7-jre-headless

buddycloud-media-server:
  archive.extracted:
    - name: /opt/buddycloud-media-server
    - source: https://dl.bintray.com/buddycloud/buddycloud-media-server/buddycloud-media-server.tgz
    - source_hash: https://dl.bintray.com/buddycloud/buddycloud-media-server/file.hashes
    - archive_format: tar
    - tar_options: z
    
/srv/buddycloud-media-server-filestore:
    file.directory:
    - user: buddycloud
    - group: buddycloud
    - dir_mode: 700
    - file_mode: 600
    - recurse:
        - user
        - group
        - mode

/opt/buddycloud-media-server/mediaserver.properties:
  file.managed:
    - source: salt://buddycloud-media-server/mediaserver.properties.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/opt/buddycloud-media-server/logback.xml:
  file.managed:
    - source: salt://buddycloud-media-server/logback.xml
    - user: root
    - group: root
    - mode: 644

create-buddycloud-media-server-schema:
  cmd.run:
    - name: cat /opt/buddycloud-media-server/postgres/*sql | psql -h {{ salt['pillar.get']('buddycloud:lookup:database-server') }} -U {{ salt['pillar.get']('buddycloud:lookup:env') }}_mediaserver {{ salt['pillar.get']('buddycloud:lookup:env') }}_mediaserver
    - env:
      - PGPASSWORD: '{{ salt['pillar.get'](pgpassword) }}'

# create the jid for testing permissions
create-media-xmpp-user-account:
    cmd.run:
          - name: echo -e "{{ salt['pillar.get']('buddycloud:lookup:media-jid-password') }}\n{{ salt['pillar.get']('buddycloud:lookup:media-jid-password') }}" | prosodyctl adduser mediaserver-test@{{ salt['pillar.get']('buddycloud:lookup:domain') }} | true

/var/log/buddycloud-media-server:
  file.absent

/etc/nginx/sites-enabled/buddycloud-media-server.vhost.conf:
  file.managed:
    - source: salt://buddycloud-media-server/nginx-vhost.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/init/buddycloud-media-server.conf:
  file.managed:
    - source: salt://buddycloud-media-server/upstart-script
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: buddycloud-media-server
    - enable: True
    - force_reload: True
    - full_restart: True
    - require:
      - archive: buddycloud-server-java
      - archive: buddycloud-media-server
      - pkg: media-server-dependencies
      - file: /opt/buddycloud-media-server/mediaserver.properties
      - file: /opt/buddycloud-media-server/logback.xml
      - cmd: create-buddycloud-media-server-schema
