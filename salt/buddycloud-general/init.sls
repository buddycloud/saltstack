certificates-group:
  group.present:
    - name: certificates 
    - system: True

buddycloud-group:
  group.present:
    - name: buddycloud
    - system: True

buddycloud-user:
  user.present:
    - name: buddycloud
    - gid: buddycloud
    - groups:
      - buddycloud
      - certificates

/var/log/buddycloud:
  file.directory:
    - user: buddycloud
    - group: buddycloud
    - mode: 755
    - recurse:
      - user
      - group
