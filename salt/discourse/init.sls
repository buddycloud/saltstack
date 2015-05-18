{% set env = pillar['discourse']['env'] %}
{% set ruby_version = pillar['discourse']['ruby-version'] %}

include:
  - .database
  - .nginx
  - .redis
  - .ruby

discourse-deps:
  pkg.installed:
    - pkgs:
      - git
      - libtool
      - libxslt-dev
      - libxml2-dev
      - libpq-dev
      - gawk 
      - curl
      - pngcrush
      - imagemagick
      - python-software-properties

discourse:
  user.present:
    - shell: /bin/bash

/home/discourse/.profile:
  file.managed:
    - source: salt://discourse/profile.jinja
    - template: jinja
    - require:
      - user: discourse

/home/discourse/.bash_aliases:
  file.managed:
    - contents: alias bluepill="NOEXEC_DISABLE=1 bluepill --no-privileged -c ~/.bluepill"
    - require:
      - user: discourse

ruby-{{ ruby_version }}:
  rvm.installed:
    - default: True
    - user: discourse
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - user: discourse

bundler:
  gem.installed:
    - user: discourse
    - ruby: ruby-{{ ruby_version }}
    - require:
      - rvm: ruby-{{ ruby_version }}

bluepill:
  gem.installed:
    - user: discourse
    - ruby: ruby-{{ ruby_version }}
    - require:
      - rvm: ruby-{{ ruby_version }}

/var/www:
  file.directory:
    - user: discourse
    - require:
      - user: discourse

discourse-repo:
  git.latest:
    - name: https://github.com/discourse/discourse.git
    - rev: {{ pillar['discourse']['version'] }}
    - target: /var/www/discourse
    - runas: discourse
    - force: True
    - require:
      - pkg: discourse-deps
      - file: /var/www

# /var/www/discourse/.ruby-version:
#   file.managed:
#     - contents: {{ ruby_version }}
#     - require:
#       - git: discourse-repo

/var/www/discourse/config/database.yml:
  file.managed:
    - source: salt://discourse/database.yml.jinja
    - template: jinja
    - require:
      - git: discourse-repo
    - require_in:
      - cmd: app-db-setup

/var/www/discourse/config/redis.yml:
  file.managed:
    - source: salt://discourse/redis.yml
    - require:
      - git: discourse-repo
    - require_in:
      - cmd: app-db-setup

/var/www/discourse/config/discourse.pill:
  file.managed:
    - source: salt://discourse/discourse.pill.jinja
    - template: jinja
    - require:
      - git: discourse-repo
    - require_in:
      - cmd: app-db-setup

/var/www/discourse/config/environments/{{ env }}.rb:
  file.managed:
    - source: salt://discourse/environment.rb.jinja
    - template: jinja
    - require:
      - git: discourse-repo
    - require_in:
      - cmd: app-db-setup

# FIXME: Only run when the repo is updated
app-bundle:
  cmd.run:
    - user: discourse
    - env:
      RUBY_GC_MALLOC_LIMIT: 90000000
    - cwd: /var/www/discourse
    - shell: /bin/bash
    - name: bundle install --without test --deployment
    - require:
      - git: discourse-repo
      - gem: bundler
      - user: discourse

# FIXME: Only run when the repo is updated
app-db-setup:
  cmd.run:
    - name: bundle exec rake db:migrate
    - user: discourse
    - env:
      RUBY_GC_MALLOC_LIMIT: 90000000
      RAILS_ENV: {{ env }}
    - cwd: /var/www/discourse
    - shell: /bin/bash
    - require:
      - cmd: app-bundle
      - postgres_database: discourse_{{ env }}

app-assets-setup:
  cmd.run:
    - name: bundle exec rake assets:precompile
    - user: discourse
    - env:
      RUBY_GC_MALLOC_LIMIT: 90000000
      RAILS_ENV: {{ env }}
    - cwd: /var/www/discourse
    - shell: /bin/bash
    - require:
      - cmd: app-db-setup
      - postgres_database: discourse_{{ env }}

/etc/init/discourse-bluepill.conf:
  file.managed:
    - source: salt://discourse/bluepill.conf.jinja
    - template: jinja
    - watch_in:
      - discourse-bluepill

discourse-bluepill:
  service.running

