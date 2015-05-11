{% from "nginx/map.jinja" import nginx as nginx_map with context %}

/var/www/:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 0755
    - makedirs: True

/usr/share/nginx:
  file:
    - directory

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent
{% endfor %}

/etc/nginx:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://nginx/nginx.conf.jinja
    - require:
      - file: /etc/nginx
    - context:
      default_user: www-data
      default_group: www-data

{% for dir in ('sites-enabled', 'sites-available') %}
/etc/nginx/{{ dir }}:
  file.directory:
    - user: root
    - group: root
{% endfor -%}

nginx_service:
  service.running:
    - enable: True
    - name: nginx

distro_nginx_package:
  pkg.installed:
    - name: nginx
    - require_in:
      - service: nginx_service

nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/nginx.conf.jinja
    - template: jinja
    - context:
      config_pillar_get_path: "nginx_config"
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx_service
