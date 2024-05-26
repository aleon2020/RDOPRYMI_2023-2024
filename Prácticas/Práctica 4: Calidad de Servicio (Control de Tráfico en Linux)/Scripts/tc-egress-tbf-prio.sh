#!/bin/sh

INTERFACE="eth1"

# Configuración de TBF con un ancho de banda de 1.5mbit, cubeta de 10k y latencia 20s.
tc qdisc add dev $INTERFACE root handle 1: tbf rate 1.5mbit burst 10k latency 20s

# Crea la disciplina de cola.
tc qdisc add dev $INTERFACE parent 1:0 handle 10:0 prio

# PRIORIDAD 1 (MÁS PRIORITARIO)
# Tráfico de la dirección IP origen de pc1.
tc filter add dev $INTERFACE parent 10:0 prio 1 protocol ip u32 \
	match ip src 11.211.0.10/32 flowid 10:1

# PRIORIDAD 2 (PRIORIDAD INTERMEDIA)
# Tráfico de la dirección IP origen de pc2.
tc filter add dev $INTERFACE parent 10:0 prio 2 protocol ip u32 \
	match ip src 11.211.0.20/32 flowid 10:2

# PRIORIDAD 3 (MENOS PRIORITARIO)
# Sin definir, ya que no se necesita.
