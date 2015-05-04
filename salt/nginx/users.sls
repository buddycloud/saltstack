{% from "nginx/map.jinja" import nginx with context %}
{% set htauth = nginx.get('htpasswd', '/etc/nginx/.htpasswd') -%}

htpasswd:
  pkg.installed:
    - name: {{ nginx.apache_utils }}

{% for name, user in pillar.get('users', {}).items() %}
{% if user['webauth'] is defined -%}

nginx_user_{{name}}:
  module.run:
    - name: basicauth.adduser
    - user: {{ name }}
    - passwd: {{ user['webauth'] }}
    - path: {{ htauth }}
    - require:
      - pkg: htpasswd

{% endif -%}
{% endfor %}