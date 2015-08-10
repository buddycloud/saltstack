buddyclould-downloads-dependencies:
  pkg.installed:
    - pkgs:
      - nginx

/etc/nginx/sites-enabled/downloads.buddycloud.com.conf:
  file.managed:
    - source: salt://buddycloud-downloads/nginx-vhost.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
