ntp:
  pkg:        
   - installed
service:
  - running
  - enable: True
  - require:
    - pkg: ntp


