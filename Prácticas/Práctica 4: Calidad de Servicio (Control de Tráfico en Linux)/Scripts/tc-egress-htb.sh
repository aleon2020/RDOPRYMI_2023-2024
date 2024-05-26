#!/bin/sh

INTERFACE="eth1"
PC1_IP="11.211.0.10/32"
PC2_IP="11.211.0.20/32"

# Crea la disciplina de cola.
tc qdisc add dev $INTERFACE root handle 1:0 htb

# Disciplina HTB de salida con ancho de banda 1.2mbit.
tc class add dev $INTERFACE parent 1:0 classid 1:1 htb rate 1.2mbit

# 700kbit para el tráfico con origen en pc1 (ceil 700kbit).
# MODIFICAR POR 1.2mbit.
tc class add dev $INTERFACE parent 1:1 classid 1:2 htb rate 700kbit ceil 1.2mbit

# 500kbit para el tráfico con origen en pc2 (ceil 500kbit).
tc class add dev $INTERFACE parent 1:1 classid 1:3 htb rate 500kbit ceil 1.2mbit

# FLUJO 1
tc filter add dev $INTERFACE parent 1:0 protocol ip prio 1 u32 \
	match ip src $PC1_IP \
	flowid 1:2

# FLUJO 2
tc filter add dev $INTERFACE parent 1:0 protocol ip prio 1 u32 \
	match ip src $PC2_IP \
	flowid 1:3
