/etc/nginx/conf.d/discourse.conf:
  file.managed:
    - source: salt://discourse/nginx.conf.jinja
    - template: jinja
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx
