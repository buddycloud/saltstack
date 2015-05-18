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
    - buddycloud-hosting
    - buddycloud-pusher
    - buddycloud-http-api
  abyss.buddycloud.com:
    - postgres
    - nginx
    - ruby
    - discourse


