# Not needed with the upstream package
old-nginx-config:
  file.absent:
    - names:
      - /etc/nginx/sites-enabled/default
      - /etc/nginx/conf.d/default.conf
      - /etc/nginx/conf.d/example_ssl.conf
    - watch_in:
      - service: nginx

/etc/nginx/conf.d/discourse.conf:
  file.managed:
    - source: salt://discourse/nginx.conf.jinja
    - template: jinja
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx

nginx-firewall-81:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 81
    - proto: tcp
    - save: True

