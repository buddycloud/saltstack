buddycloud-hosting-dependencies:
  pkg.installed:
    - name: libssl1.0.0
    - name: openssl
    - name: python-setuptools
    - name: python
    - name: libpq-dev 
    - name: python-dev
    - name: python-pip
    - name: python-sleekxmpp
    - name: python-flask
    - name: python-pysqlite
    - name: python-flask-login
    - name: python-wtforms
    - name: python-dnspython

create-hosting-account:
  cmd.run:
    - name: psql -h {{ salt['pillar.get']('buddycloud:lookup:database-server') }} -U {{ salt['pillar.get']('buddycloud:lookup:env') }}_tigase {{ salt['pillar.get']('buddycloud:lookup:env') }}_tigase -c "SELECT TigAddUserPlainPw('{{ salt['pillar.get']('buddycloud:lookup:hosting-admin-username') }}@{{ salt['pillar.get']('buddycloud:lookup:domain') }}', '{{ salt['pillar.get']('buddycloud:lookup:hosting-admin-password') }}');"
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('buddycloud:lookup:env') }}_{{ salt['pillar.get']('postgres:users:tigase:password') }}'

# need to do this a nicer way
#buddycloud-hosting:
#  pkg.installed:
#    - sources:
#      - buddycloud-hosting: https://build.buddycloud.com/job/hosting-si/ws/buddycloud-hosting_20140731.git.f46c749-1_all.deb

# this doesn't work either... so for the moment manually installing until a nicer solution can be found
#hosting:
#  pkg.installed:
#  - sources:
#    - hosting: /root/buddycloud-package/projects/hosting/docker/hosting.deb

# take 3 also not...  :(
#hosting:
#  pkg:
#    - installed
#      - sources:
#        - hosting: /root/buddycloud-package/projects/hosting/docker/hosting.deb

/usr/share/buddycloud-hosting/logging.cfg:
  file.managed:
    - source: salt://buddycloud-hosting/logging.cfg
    - user: root
    - group: root
    - mode: 644

/usr/share/buddycloud-hosting/hosting.cfg:
  file.managed:
    - source: salt://buddycloud-hosting/buddycloud-hosting.cfg.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-enabled/buddycloud-hosting.conf:
  file.managed:
    - source: salt://buddycloud-hosting/hosting.nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

buddycloud-hosting:
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: /usr/share/buddycloud-hosting/hosting.cfg
      - file: /usr/share/buddycloud-hosting/logging.cfg
