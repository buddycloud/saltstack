buddycloud-hosting-dependencies:
  pkg.installed:
    - name: libssl1.0.0
    - name: openssl
    - name: python-setuptools
    - name: python

create-hosting-account:
  cmd.run:
    - name: psql -h abyss.buddycloud.com -U buddycloud_media_server buddycloud_media_server -c "SELECT TigAddUserPlainPw('#HOSTING_ADMIN_XMPP_CLIENT#', '#HOSTING_ADMIN_XMPP_PASS#');"
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:users:buddycloud_media_server:password') }}'

/usr/share/buddycloud-hosting/logging.cfg:
  file.managed:
    - source: salt://buddycloud-hosting/logging.cfg
    - user: root
    - group: root
    - mode: 644

# install the hosting package
#ADD hosting.deb /tmp/hosting.deb
#RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/hosting.deb
#ADD buddycloud-hosting.cfg /usr/share/buddycloud-hosting/hosting.cfg
#ADD logging.cfg /usr/share/buddycloud-hosting/logging.cfg

#ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/logstash.conf & cd /usr/share/buddycloud-hosting; python run.py
#EXPOSE 3000

