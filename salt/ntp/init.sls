# NTP Packages
ntp-pkgs:
  pkg.installed:
    - names:
      - ntp
      - tzdata

# Remember ntpdate only runs at boot time - ntpd takes
# care of things after
ntpdate:
  pkg:
    - installed
    - require:
      - pkg: ntp-pkgs
  service:
    - enabled

# NTP Service
ntpd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ntp.conf
      - pkg: ntp-pkgs

# NTP Configuration File
/etc/ntp.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0440'
    - template: jinja
    - source: salt://ntp/ntp.conf.jinja
    - require:
      - pkg: ntp-pkgs
