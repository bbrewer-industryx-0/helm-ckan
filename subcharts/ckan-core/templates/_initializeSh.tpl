{{/* vim: set filetype=sh: */}}
{{/*
Set up the primary CKAN configuration file
*/}}
{{- define "initializeSh" -}}
    #!/bin/sh

    source /usr/lib/ckan/venv/./src/ckan/contrib/docker/postgresql/docker-entrypoint-initdb.d/00_create_datastore.sh
    /usr/lib/ckan/venv/bin/python2 /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | psql -U ckan

    /usr/lib/ckan/venv/bin/python2 /usr/local/bin/ckan-paster --plugin=ckanext-validation validation init-db -c /etc/ckan/production.ini
    {{ if .Values.defaultUser }}
    echo "y
    {{ .Values.defaultUser.email }}
    {{ .Values.defaultUser.password }}
    {{ .Values.defaultUser.password }}
    " | /usr/lib/ckan/venv/bin/python2 /usr/local/bin/ckan-paster --plugin=ckan sysadmin add {{- .Values.defaultUser.username -}} -c /etc/ckan/production.ini
    {{ end }}

{{- end -}}
