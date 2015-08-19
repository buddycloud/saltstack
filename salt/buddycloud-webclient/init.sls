buddycloud-webclient:
  pkg:
    - installed
    - sources:
      - buddycloud-webclient: http://downloads.buddycloud.com/packages/debian/nightly/webclient/webclient_latest.deb

# we should fix the deb package
buddycloud-webclient-bad-config:
  file.absent:
    - name: /etc/buddycloud-webclient/config.js
    - name: /usr/share/buddycloud-webclient/config.js

# config for this domain
/usr/share/buddycloud-webclient/config.js:
  file.managed:
    - source: salt://buddycloud-webclient/buddycloud-webclient.js.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - force: True

/etc/nginx/sites-enabled/buddycloud-webclient.vhost.conf:
  file.managed:
    - source: salt://buddycloud-webclient/nginx-vhost.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
