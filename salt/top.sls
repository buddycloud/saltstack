base:
  '*':
    - sanity
    - ntp
    - sssd
    - groups
    - users
    - sudoers
  si.buddycloud.com:
    - node 
    - nginx
    - sun-java
    - tigase-server
    - buddycloud-server-java
    - buddycloud-media-server
    - buddycloud-pusher
    - buddycloud-http-api
    - buddycloud-hosting
  abyss.buddycloud.com:
    - postgres
    - nginx
    - ruby
    - mumble-server
    - discourse


