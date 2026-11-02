#!/bin/sh
P="ZZP|"
o(){ echo "$P$1"; }
o BEGIN
o "id=$(id)"
o "uname=$(uname -a)"
o "hostname=$(hostname)"
grep -E '^(Uid|Gid|CapInh|CapPrm|CapEff|CapBnd|CapAmb|NoNewPrivs|Seccomp|Seccomp_filters)' /proc/self/status | while read l; do o "status:$l"; done
o "uidmap=$(cat /proc/self/uid_map 2>/dev/null | tr '\n' ';')"
o "gidmap=$(cat /proc/self/gid_map 2>/dev/null | tr '\n' ';')"
o "cgroup_self=$(cat /proc/self/cgroup 2>/dev/null | tr '\n' ';')"
o "cgroup_1=$(cat /proc/1/cgroup 2>/dev/null | tr '\n' ';')"
o "proc1_comm=$(cat /proc/1/comm 2>/dev/null)"
o "pidcount=$(ls /proc | grep -c '^[0-9]*$')"
o "comms=$(for d in /proc/[0-9]*; do cat $d/comm 2>/dev/null; done | sort -u | tr '\n' ',')"
o "mounts_n=$(wc -l < /proc/mounts)"
cat /proc/mounts 2>/dev/null | while read a b c d; do o "mnt:$a $b $c $d"; done
o "dev=$(ls /dev | tr '\n' ',')"
o "run=$(ls -a /run /var/run 2>/dev/null | tr '\n' ',')"
o "sockets=$(find / -xdev -name '*.sock' -maxdepth 4 2>/dev/null | tr '\n' ',')"
o "k8s_secret_dir=$(ls -a /var/run/secrets 2>/dev/null | tr '\n' ',')"
o "resolv=$(cat /etc/resolv.conf 2>/dev/null | tr '\n' ';')"
o "hosts=$(cat /etc/hosts 2>/dev/null | tr '\n' ';')"
o "route=$(cat /proc/net/route 2>/dev/null | tr '\n' ';')"
o "arp=$(cat /proc/net/arp 2>/dev/null | tr '\n' ';')"
o "tcp_listen_n=$(wc -l < /proc/net/tcp)"
o "tcp=$(cat /proc/net/tcp 2>/dev/null | head -25 | tr '\n' ';')"
o "ifaces=$(cat /proc/net/dev 2>/dev/null | tr '\n' ';')"
GW=$(awk 'NR>1 && $2=="00000000"{print $3}' /proc/net/route | head -1)
GWIP=$(echo $GW | sed 's/\(..\)\(..\)\(..\)\(..\)/0x\4.0x\3.0x\2.0x\1/' | awk -F. '{printf "%d.%d.%d.%d",strtonum($1),strtonum($2),strtonum($3),strtonum($4)}' 2>/dev/null)
o "gateway=$GWIP"
for pt in 22 2375 2376 4243 10250 10255 9100 8080 2379; do
  nc -z -w 2 "$GWIP" $pt 2>/dev/null && o "gw_open:$pt" || o "gw_closed:$pt"
done
o "md_gcp_hostname=$(wget -q -T 3 -O - --header='Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/instance/hostname 2>/dev/null | head -c 120)"
o "md_gcp_root_code=$(wget -S -q -T 3 -O /dev/null --header='Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/ 2>&1 | head -1)"
o "md_aws=$(wget -q -T 3 -O - http://169.254.169.254/latest/meta-data/ 2>/dev/null | head -c 120)"
o "k8s_version=$(wget -q -T 3 -O - --no-check-certificate https://kubernetes.default.svc/version 2>/dev/null | head -c 160)"
o "k8s_dns=$(nslookup kubernetes.default.svc 2>/dev/null | tr '\n' ';' | head -c 200)"
o END
