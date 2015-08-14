# saltstack
Saltstack bits for BC

Runs on abyss.buddycloud.com

## Design choices

- install services into `/opt/buddycloud-<servicename>`
- Log everything to `/var/log/buddycloud/<service-name>.log` (makes it nice to do a `tail -F /var/log/buddycloud/*log`)
- logrotate everything
- use `buddycloud.dev` for default domain
- all services use and upstart script
- remove init.d scripts

## Todo

- clean up pillar environment to something like: `buddycloud:<env>:setting` 
```
buddycloud:
  general:
    ntp-server: 1.2.3.4
    dns-server: 1.2.3.4
  dev:
    frontend-url: http://localhost:3000
    send-address: noreply@somewhere.example
    smtp-server: abyss.buddycloud.com
    channels-xmpp-componet-password: channels-component-secret
    media-xmpp-componet-password: media-component-secret
  si:
    ...
  prod:
    ...
```
