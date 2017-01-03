{ bash, jq, curl, writeScriptBin }:

# Provides the `wt` executable, a wrapper for SSH.
#
# Usage: wt host [ssh arguments ...]
#
# If host is not an IP address, the Ansible dynamic inventory in Consul is
# searched for matching groups and hosts to get an IP address.
#
# The IP address is prefixed with wtcc/ before passing it to SSH. You probably
# want to have an entry for this pattern in your SSH configuration, e.g.:
#
#   Host wtcc/*
#   User yourlogin
#   StrictHostKeyChecking no
#   ProxyCommand ssh -qa wtcc-jump-host 'nc -w 600 $(basename %h) %p'
#
# TODO:
# - Bash auto completion on group and host


writeScriptBin "wt" ''
  #!${bash}/bin/bash

  set -o nounset
  set -o errexit
  set -o pipefail

  host="$1"
  shift

  curl=${curl}/bin/curl
  jq=${jq}/bin/jq

  # If host is not an IP address, try to get it from Ansible dynamic inventory
  # in Consul.
  if [[ ! "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "$host is not an IP address, querying inventory..." >&2

      IFS=':' read host index <<< "$host"
      index=''${index:-1}

      inventory=$($curl -s http://localhost:8500/v1/kv/inventory | $jq -r .[].Value | base64 --decode)

      groups=
      if echo "$inventory" | $jq -e "has(\"$host\")" > /dev/null; then
          groups="$host"
      else
          groups=$(echo "$inventory" | $jq -r "keys[] | select(contains(\"$host\"))")
      fi

      hosts=
      if [ -n "$groups" ]; then
          echo "$(echo "$groups" | wc -l) matching groups:" >&2
          echo "$groups" | sed 's/^/  /' >&2
          hosts=$(for group in $groups; do
                    echo "$inventory" | $jq -r ".$group[]"
                  done)
      else
          hosts=$(echo "$inventory" | $jq -r ".all[] | select(contains(\"$host\"))")
      fi

      if [ -z "$hosts" ]; then
          echo "No matching hosts" >&2
          exit 1
      fi

      hosts=$(echo "$hosts" | sort | uniq)

      echo "$(echo "$hosts" | wc -l) matching hosts:" >&2
      echo "$hosts" | sed 's/^/  /' >&2

      host=$(echo "$hosts" | head -$index | tail -1)
      echo "Selected host $index: $host" >&2

      host=$(echo "$inventory" | $jq -r "._meta.hostvars[\"$host\"].ansible_host")
      echo "Found IP address: $host" >&2
  fi

  ssh "wtcc/$host" "$@"
''
