#!/bin/sh

INTERFACE="eth1"

# Disciplina TBF de salida con tasa de envío de 1.5mbit, tamaño de cubeta 10k y latencia 10ms.
# !!!MODIFICAR 20s por 10ms.!!!
tc qdisc add dev $INTERFACE root handle 1: tbf rate 1.5mbit burst 10k latency 20s
