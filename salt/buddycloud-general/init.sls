# so that a few other services can write to /var/log/buddycloud
group-buddycloud:
  group.present:
    - name: buddycloud
    - system: True
    - members:
      - nobody

user-buddycloud:
  user.present:
    - name: buddycloud
    - gid: buddycloud
    - system: True

# which users can read the certificates in /etc/certificates
group-certificates:
  group.present:
    - name: certificates 
    - system: True
    - members:
      - nobody
      - buddycloud

/var/log/buddycloud:
  file.directory:
    - user: buddycloud
    - group: buddycloud
    - mode: 755
    - recurse:
      - user
      - group
