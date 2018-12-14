sudo -i
echo "vm.max_map_count = 262144" > /etc/sysctl.d/99-elasticsearch.conf
sysctl vm.max_map_count=262145