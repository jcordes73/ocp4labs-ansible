#!/bin/bash
INTERFACE_NAME=enp1s0

nmcli con down "System ${INTERFACE_NAME}"
nmcli con down "br0"
nmcli con down "br-${INTERFACE_NAME}"

nmcli con delete "System ${INTERFACE_NAME}"
nmcli con delete "br0"
nmcli con delete "br-${INTERFACE_NAME}"

virsh net-destroy default
virsh net-undefine default
virsh net-destroy br0
virsh net-undefine br0
virsh net-define bridge.xml
virsh net-start br0
virsh net-autostart br0

nmcli con add type bridge con-name br0 ifname br0 ipv6.method ignore ipv4.method auto bridge.stp no
nmcli con up br0
nmcli con add type ethernet con-name br-${INTERFACE_NAME} ifname ${INTERFACE_NAME} master br0
