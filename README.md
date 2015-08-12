# saltstack
Saltstack bits for BC

Runs on @abyss

## Design choices

- install services into `/opt/buddycloud-<servicename>`
- Log everything to `/var/log/buddycloud/<service-name>.log` (makes it nice to do a `tail -F /var/log/buddycloud/*log`)
- logrotate everything
- use `buddycloud.dev` for default domain


