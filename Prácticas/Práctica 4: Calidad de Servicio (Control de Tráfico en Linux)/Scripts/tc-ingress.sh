#!/bin/sh

INTERFACE="eth0"
PC1_IP="11.211.0.10/32"
PC2_IP="11.211.0.20/32"

# Borra la disciplina de cola si está definida, para que no dé un error.
if tc qdisc show dev $INTERFACE | grep -q "ingress"; then
    # Si devuelve algo por la salida, borra la disciplina de cola.
    tc qdisc del dev $INTERFACE ingress
fi

# Si no devuelve nada, crea la discplina de cola.
tc qdisc add dev $INTERFACE ingress handle ffff:

# FLUJO 1
# Con la dirección IP origen de pc1 se quiere restringir con TBF a una velocidad de 1mbit y una cubeta de 10k.
tc filter add dev $INTERFACE parent ffff: protocol ip prio 4 u32 match ip src $PC1_IP police rate 1mbit burst 10k drop flowid :1

# FLUJO 2
# Con la dirección IP origen de pc2 se va a restringir a una velocidad de 2mbit y una cubeta de 10k.
tc filter add dev $INTERFACE parent ffff: protocol ip prio 5 u32 match ip src $PC2_IP police rate 2mbit burst 10k drop flowid :2
