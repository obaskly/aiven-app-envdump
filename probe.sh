#!/bin/sh
P="ZZP|"
o(){ echo "$P$1"; }
o BEGIN
o "containerenv=$(cat /run/.containerenv 2>/dev/null | tr '\n' ';')"
o "ls_secrets=$(ls -la /secrets 2>&1 | tr '\n' ';')"
o "ls_run_secrets=$(ls -la /run/secrets 2>&1 | tr '\n' ';')"
o "secrets_files=$(find /secrets -type f 2>/dev/null | while read f; do echo "$f:$(wc -c <$f)"; done | tr '\n' ',')"
o "ls_alloc=$(ls -la /alloc 2>&1 | tr '\n' ';')"
o "ls_local=$(ls -la /local 2>&1 | tr '\n' ';')"
o "alloc_tree=$(find /alloc -maxdepth 3 2>/dev/null | head -80 | tr '\n' ',')"
o "local_tree=$(find /local -maxdepth 3 2>/dev/null | head -80 | tr '\n' ',')"
o "df=$(df -h 2>/dev/null | tr '\n' ';')"
o "ip6=$(ip -6 addr 2>/dev/null | tr '\n' ';')"
o "ip4=$(ip addr 2>/dev/null | tr '\n' ';')"
o "tcp6=$(cat /proc/net/tcp6 2>/dev/null | head -20 | tr '\n' ';')"
for h in 169.254.1.2 10.132.0.1 169.254.1.1; do
  for pt in 22 53 80 443 2375 2379 4243 8080 8443 9090 9100 10250 10255; do
    nc -z -w 2 "$h" $pt 2>/dev/null && o "open:$h:$pt"
  done
  o "scanned:$h"
done
o "dns_net=$(nslookup aiven-application-infrastructure.aiven.local 2>&1 | tr '\n' ';' | head -c 300)"
o "dns_soa=$(nslookup -type=soa aiven.local 2>&1 | tr '\n' ';' | head -c 300)"
o "dns_ns=$(nslookup -type=ns aiven.local 2>&1 | tr '\n' ';' | head -c 300)"
o "dns_self=$(nslookup nc-f2b727e8-cd64-527e-ac96-a4758e497715-334.aiven-application-infrastructure.aiven.local 2>&1 | tr '\n' ';' | head -c 300)"
o "dns_api=$(nslookup api.aiven.local 2>&1 | tr '\n' ';' | head -c 200)"
o "dns_meta=$(nslookup metadata.aiven.local 2>&1 | tr '\n' ';' | head -c 200)"
o "dns_host=$(nslookup host.containers.internal 2>&1 | tr '\n' ';' | head -c 200)"
o "hostmeta_hdr=$(wget -S -q -T 3 -O /dev/null http://169.254.1.2/ 2>&1 | head -3 | tr '\n' ';')"
o "env_names=$(env | cut -d= -f1 | sort | tr '\n' ',')"
o END
