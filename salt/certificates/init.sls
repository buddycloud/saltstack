# any process belonging to the certificates group can read the certificate files
certificates:
  group.present:
    - system: True

/etc/certificates:
  file.directory:
    - user: root
    - group: certificates
    - mode: 755
    - makedirs: True

/etc/certificates/dh4096.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - contents_pillar: dh:param

{% for domain_name in ['buddycloud.com','buddycloud.net','buddycloud.org'] %}
/etc/certificates/{{domain_name}}.cert.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - contents_pillar: ssl:{{domain_name}}:cert

/etc/certificates/{{domain_name}}.key.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - contents_pillar: ssl:{{domain_name}}:key

/etc/certificates/{{domain_name}}.intermediate.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - contents_pillar: ssl:{{domain_name}}:intermediate

/etc/certificates/{{domain_name}}.ca.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - contents_pillar: ssl:{{domain_name}}:ca

/etc/certificates/{{domain_name}}.complete.pem:
  file.managed:
    - makedirs: True
    - user: root
    - group: certificates
    - mode: 640
    - template: jinja
    - source: salt://certificates/complete-pem-template.jinja
    - context:
      domain_name: {{ domain_name }}
{% endfor %}
