redis-repo:
  pkgrepo.managed:
    - humanname: Redis PPA
    - ppa: rwky/redis
    - require_in:
      - pkg: redis-server

redis-server:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: redis-server
