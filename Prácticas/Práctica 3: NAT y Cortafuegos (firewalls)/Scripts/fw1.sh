#!/bin/bash

# Apartado 2.1

# Borra las reglas que hubiese configuradas previamente en la tabla nat
iptables -t nat -F

# Reinicia los contadores de la tabla nat
iptables -t nat -Z

# Realiza la traducción de direcciones para el tráfico saliente de las redes
# privadas (SNAT) y su correspondiente tráfico de respuesta
iptables -t nat -A POSTROUTING -s 10.211.0.0/16 -o eth2 -j SNAT --to-source 100.211.1.100
