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
  pkg:
    - installed
    - sources:
      - buddycloud-media-server: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-media-server/buddycloud-media-server_latest.deb

/srv/buddycloud-media-server-filestore:
    file.directory:
    - user: nobody
    - group: nogroup
    - dir_mode: 700
    - file_mode: 600
    - recurse:
        - user
        - group
        - mode

/usr/share/buddycloud-media-server/mediaserver.properties:
  file.managed:
    - source: salt://buddycloud-media-server/mediaserver.properties.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/usr/share/buddycloud-media-server/logback.xml:
  file.managed:
    - source: salt://buddycloud-media-server/logback.xml
    - user: root
    - group: root
    - mode: 644

create-buddycloud-media-server-schema:
  cmd.run:
    - name: psql -h {{ salt['pillar.get']('buddycloud:lookup:database-server') }} -U {{ salt['pillar.get']('buddycloud:lookup:env') }}_mediaserver {{ salt['pillar.get']('buddycloud:lookup:env') }}_mediaserver -f /usr/share/dbconfig-common/data/buddycloud-media-server/install/pgsql
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
      - pkg: buddycloud-server-java
      - pkg: buddycloud-media-server
      - pkg: media-server-dependencies
      - file: /usr/share/buddycloud-media-server/mediaserver.properties
      - file: /usr/share/buddycloud-media-server/logback.xml
      - cmd: create-buddycloud-media-server-schema
