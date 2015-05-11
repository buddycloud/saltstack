ruby:
  pkg.installed:
    - names:
      - ruby1.9.3
    - require:
      - pkg: old_ruby_purged
