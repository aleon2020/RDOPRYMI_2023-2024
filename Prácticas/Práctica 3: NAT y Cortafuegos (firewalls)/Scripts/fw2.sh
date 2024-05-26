#!/bin/sh

# Apartado 2.2.1

# Borra las reglas que hubiese configuradas previamente en la tabla nat
iptables -t nat -F

# Reinicia los contadores de la tabla nat
iptables -t nat -Z

# El tráfico de entrada al firewall destinado al puerto TCP 80
# es redirigido al puerto 80 de pc3.
iptables -t nat -A PREROUTING -i eth2 -d 100.211.1.100 -p tcp --dport 80 -j DNAT --to-destination 10.211.2.30:80

# Apartado 2.2.2

# El tráfico de entrada al firewall destinado al puerto UDP 5001
# es redirigido al puerto 5001 de pc1
iptables -t nat -A PREROUTING -i eth2 -d 100.211.1.100 -p udp --dport 5001 -j DNAT --to-destination 10.211.0.10:5001

# El tráfico de entrada al firewall destinado al puerto UDP 5002
# es redirigido al puerto 5001 de pc2
iptables -t nat -A PREROUTING -i eth2 -d 100.211.1.100 -p udp --dport 5002 -j DNAT --to-destination 10.211.0.20:5001
