certificates-group:
  group.present:
    -name: certificates 
    - system: True

buddycloud-group:
  group.present:
    - name: buddycloud
    - system: True

buddycloud-user:
  user.present:
    - name: buddycloud
    - groups:
      - buddycloud
