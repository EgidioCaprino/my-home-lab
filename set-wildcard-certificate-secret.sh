#!/usr/bin/env bash

set -xe

namespaces=('kitchen-owl' 'invidious' 'jellyfin' 'nextcloud' 'vaultwarden')
certificate_file='/etc/letsencrypt/live/egidiocaprino.com/fullchain.pem'
private_key_file='/etc/letsencrypt/live/egidiocaprino.com/privkey.pem'

for namespace in "${namespaces[@]}"; do
  /usr/bin/kubectl --namespace "${namespace}" delete secret "${namespace}-certificate"
  /usr/bin/kubectl --namespace "${namespace}" create secret tls "${namespace}-certificate" --cert "${certificate_file}" --key "${private_key_file}"
done
