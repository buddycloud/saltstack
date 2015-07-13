base:
  '*':
    - sanity
    - time
    - sssd
    - groups
    - users
    - sudoers
    - certificates
  si.buddycloud.com:
    - node 
    - nginx
    - sun-java
    - tigase-server
    - buddycloud-server-java
    - buddycloud-media-server
    - buddycloud-pusher
    - buddycloud-hosting
    - buddycloud-http-api
    - buddycloud-webapps
  abyss.buddycloud.com:
    - postgres
    - nginx
    - ruby
    - mumble-server
    - discourse


