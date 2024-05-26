#!/bin/sh

tc qdisc add dev eth2 root handle 1:0 dsmark indices 8 set_tc_index

tc filter add dev eth2 parent 1:0 protocol ip prio 1 \
	tcindex mask 0xfc shift 2
	
tc qdisc add dev eth2 parent 1:0 handle 2:0 htb

# Configuración de HTB con ancho de banda 2.4Mbit para compartir entre todos los flujos
tc class add dev eth2 parent 2:0 classid 2:1 htb rate 2.4Mbit

# EF: HTB 1Mbit como mı́nimo y 1Mbit como máximo.
tc class add dev eth2 parent 2:1 classid 2:10 htb rate 1Mbit ceil 1Mbit

# AF31: HTB 500kbit como mı́nimo y 500kbit como máximo.
tc class add dev eth2 parent 2:1 classid 2:11 htb rate 500kbit ceil 500kbit

# AF21: HTB 400kbit como minimo y 400kbit como máximo.
tc class add dev eth2 parent 2:1 classid 2:12 htb rate 400kbit ceil 400kbit

# AF11: HTB 200kbit como mı́nimo y 200kbit como máximo.
tc class add dev eth2 parent 2:1 classid 2:13 htb rate 200kbit ceil 200kbit


tc filter add dev eth2 parent 2:0 protocol ip prio 1 \
	handle 0x2e tcindex classid 2:10


tc filter add dev eth2 parent 2:0 protocol ip prio 1 \
	handle 0x1a tcindex classid 2:11


tc filter add dev eth2 parent 2:0 protocol ip prio 1 \
	handle 0x12 tcindex classid 2:12


tc filter add dev eth2 parent 2:0 protocol ip prio 1 \
	handle 0x0a tcindex classid 2:13
