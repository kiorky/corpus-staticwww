{% set cfg = opts.ms_project %}
{% set data = cfg.data %}

include:
  - makina-projects.{{cfg.name}}.fixperms

# copy somewhere that nginx can access !

{{cfg.name}}-sync-docroot:
  cmd.run:
    - onlyif: |
              {{data.docroot_origin_test}}
    - name: |
        rsync \
           {{data.docroot_origin_rsync_opts}} \
          "{{data.docroot_origin}}/" \
          "{{data.doc_root}}/"
    - watch_in:
      - file: {{cfg.name}}-restricted-perms
