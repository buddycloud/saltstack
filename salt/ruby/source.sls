{% set ruby = pillar.get('ruby', {}) -%}
{% set version = ruby.get('version', '2.0.0-p247') -%}
{% set checksum = ruby.get('checksum', 'md5=c351450a0bed670e0f5ca07da3458a5b') -%}
{% set source = ruby.get('source_root', '/usr/local/src') -%}

{% set ruby_package = source + '/ruby-' + version + '.tar.gz' -%}

get_ruby:
  pkg.installed:
      - names:
        - libcurl4-openssl-dev 
        - libexpat1-dev 
        - gettext 
        - libz-dev 
        - libssl-dev
        - build-essential
  file.managed:
    - name: {{ ruby_package }}
    - source: ftp://ftp.ruby-lang.org/pub/ruby/ruby-{{ version }}.tar.gz
    - source_hash: {{ checksum }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ ruby_package }}
    - require:
      - pkg: get_ruby
    - watch:
      - file: get_ruby

ruby:
  cmd.wait:
    - cwd: {{ source + '/ruby-' + version }}
    - name: ./configure && make && make install
    - watch:
      - cmd: get_ruby
    - require:
      - cmd: get_ruby
      - pkg: old_ruby_purged
