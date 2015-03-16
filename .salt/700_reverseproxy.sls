{% import "makina-states/services/monitoring/circus/macros.jinja" as circus with context %}
{% import "makina-states/services/http/nginx/init.sls" as nginx %}

{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

include:
  - makina-states.services.http.nginx

# inconditionnaly reboot circus & nginx upon deployments
/bin/true:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-conf-hook

{{ nginx.virtualhost(domain=data.domain, doc_root=data.doc_root,
                     server_aliases=data.server_aliases,
                     vhost_basename='corpus-'+cfg.name,
                     vh_top_source=data.nginx_upstreams,
                     vh_content_source=data.nginx_vhost,
                     cfg=cfg)}}
