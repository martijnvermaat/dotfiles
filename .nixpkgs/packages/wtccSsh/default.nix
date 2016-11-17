{ bash, consul, writeScriptBin }:

# Provides the `wtcc` executable, a wrapper for SSH.
#
# Usage: wtcc host [ssh arguments ...]
#
# If host not an IP address, Consul is searched for matching hostnames to get
# an IP address.
#
# The IP address is prefixed with wtcc/ before passing it to SSH. You probably
# want to have an entry for this pattern in your SSH configuration, e.g.:
#
#   Host wtcc/*
#   User yourlogin
#   StrictHostKeyChecking no
#   ProxyCommand ssh -qa wtcc-jump-host 'nc -w 600 $(basename %h) %p'

writeScriptBin "wtcc" ''
  #!${bash}/bin/bash

  set -o nounset
  set -o errexit
  set -o pipefail

  host="$1"
  shift

  # If host is not an IP address, try to get it from Consul.
  if [[ ! "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      host=$(${consul}/bin/consul members | awk "\$3 == \"alive\" && \$1 ~ /$host/ {print \$2; exit}" | cut -d : -f 1)
      echo "Found IP in Consul: $host"
  fi

  ssh "wtcc/$host" "$@"
''
