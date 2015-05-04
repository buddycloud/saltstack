# Authenticate with LDAP and create user's home direcories

sssd-dependencies:
  pkg.installed:
    - name: sssd-tools
    - name: sssd-ldap
    - name: libnss-sss
    - name: libpam-sss
    - name: libpam-modules

sssd:
  pkg:
    - installed
  service:
    - running
    - file: /etc/sssd/sssd.conf
  require:
    - pkg: sssd-dependencies

/etc/sssd/sssd.conf:
  file:
    - managed
    - source: salt://sssd/sssd.conf
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: sssd

/usr/share/pam-configs/mkhomedir.conf:
  file:
    - managed
    - source: salt://sssd/mkhomedir.conf
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: libpam-modules
  cmd.wait:
    - name: pam-auth-update --package
    - watch:
      - file: /usr/share/pam-configs/mkhomedir.conf
