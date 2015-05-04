base:
  '*':
    - sanity
    - sssd
  prod.buddycloud.com:
    - node 
    - buddycloud-http-api
    - nginx
  abyss.buddycloud.com:
    - nginx
    - discourse


