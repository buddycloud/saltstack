jenins-dependencies:
  pkg.installed:
    - pkgs:
      - libssl1.0.0
      - openssl
      - openjdk-7-jre-headless

/etc/nginx/sites-enabled/build.buddycloud.com.conf:
  file.managed:
    - source: salt://jenkins/nginx-vhost.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

jenkins:
  pkg.installed:
    - pkgs: 
      - jenkins
  service.running:
    - enable: True
    - watch:
      - pkg: jenkins
