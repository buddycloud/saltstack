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
  prod.buddycloud.com:
    - buddycloud-http-api
  abyss.buddycloud.com:
    - node
    - postgres
    - nginx
    - ruby
    - mumble-server
    # - discourse
    - buddycloud-downloads
    - buddycloud-http-api
    - buddycloud-angular-app
  crater.buddycloud.com:
    - buddycloud-ddns

