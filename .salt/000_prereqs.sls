{% set cfg = opts.ms_project %}
{% set data = cfg.data %}

{{cfg.name}}-www-data:
  user.present:
    - name: www-data
    - optional_groups:
      - {{cfg.group}}
    - remove_groups: false
    - system: true

prepreqs-{{cfg.name}}:
  pkg.installed:
    - watch:
      - user: {{cfg.name}}-www-data
    - pkgs:
      - apache2-utils
      - libgeoip-dev
      - rsync

{{cfg.name}}-dirs:
  file.directory:
    - makedirs: true
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - watch:
      - pkg: prepreqs-{{cfg.name}}
      - user: {{cfg.name}}-www-data
    - names:
      - {{data.doc_root}}

{{cfg.name}}-index:
  file.managed:
    - name: "{{data.index}}"
    - user: www-data
    - group: {{cfg.group}}
    - makedirs: true
    - contents: "<html><body>It works</body></html"
    - unless: |
              set -x
              if test -e "{{data.index}}";then exit 0;fi
              {{data.docroot_origin_test}}
    - watch:
      - pkg: prepreqs-{{cfg.name}}
      - user: {{cfg.name}}-www-data
      - file: {{cfg.name}}-dirs
