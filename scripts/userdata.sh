#!/bin/bash

configure_private_ip_address () {
  cat << EOS > /etc/netplan/01-netcfg.yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        ens192:
            dhcp4: yes
            dhcp6: yes
            dhcp-identifier: mac
        ens224:
            dhcp4: no
            dhcp6: no
            addresses: [${private_ip_address}]
EOS
  netplan apply
}

configure_ssh_port () {
  sed -i 's/^#*Port [0-9]*/Port ${custom_ssh_port}/' /etc/ssh/sshd_config
}

configure_private_ip_address
configure_ssh_port