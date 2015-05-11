include:
{% if pillar.get('ruby', {}).get('install_from_source') %}  
  - ruby.source
{% else %}
  - ruby.package
{% endif %}

old_ruby_purged:
  pkg.purged:
    - names:
      - ruby1.8 
      - rubygems
      - rake
      - ruby-dev
      - libreadline5 
      - libruby1.8 
      - ruby1.8-dev
