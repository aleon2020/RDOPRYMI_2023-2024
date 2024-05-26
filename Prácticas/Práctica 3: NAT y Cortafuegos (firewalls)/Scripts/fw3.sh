#!/bin/sh

# Apartado 2.1

# Borra las reglas que hubiese configuradas previamente en la tabla nat
iptables -t nat -F

# Reinicia los contadores de la tabla nat
iptables -t nat -Z

# Realiza la traducción de direcciones para el tráfico saliente de las redes
# privadas (SNAT) y su correspondiente tráfico de respuesta
iptables -t nat -A POSTROUTING -s 10.211.0.0/16 -o eth2 -j SNAT --to-source 100.211.1.100

# Apartado 3

# PREGUNTA 1

# Borra las reglas que hubiese configuradas previamente en la tabla filter
iptables -t filter -F

# Reinicia los contadores de la tabla nat
iptables -t filter -Z

# PREGUNTA 2

# Fija las políticas por defecto de las cadenas de la tabla filter, haciendo 
# que por defecto se descarte todo el tráfico en el firewall excepto los
# paquetes que cree el propio firewall (configuración habitual en un firewall).
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT ACCEPT

# PREGUNTA 3

# Permite el tráfico de entrada dirigido a las aplicaciones que se están
# ejecutando en el propio firewall únicamente si este tráfico tiene su
# origen en las subredes privadas de la empresa.
iptables -t filter -A INPUT -i eth0 -j ACCEPT

# PREGUNTA 4

# Permite todo el tráfico saliente desde las subredes privadas hacia Internet
# y el tráfico de respuesta al saliente.
iptables -t filter -A FORWARD -i eth0 -o eth2 -j ACCEPT
iptables -t filter -A FORWARD -i eth2 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# PREGUNTA 5

# Permite desde Internet únicamente el tráfico entrante nuevo hacia la zona
# DMZ según las siguientes reglas:

# Acceso a un servidor echo existente en pc4 (UDP, puerto 7), donde el servidor
# de echo es un servidor que al enviarle una cadena de caracteres, devuelve la
# misma cadena que se le ha enviado.
iptables -t filter -A FORWARD -i eth2 -o eth1 -d 100.211.0.40 -p udp --dport 7 -j LOG --log-prefix echo
iptables -t filter -A FORWARD -i eth2 -o eth1 -d 100.211.0.40 -p udp --dport 7 -j ACCEPT

# Acceso a un servidor daytime existente en pc5 (UDP, puerto 13), donde el 
# servidor daytime es un servidor que al enviarle algo, devuelve la fecha y 
# hora de la máquina donde está instalado.
iptables -t filter -A FORWARD -i eth2 -o eth1 -d 100.211.0.50 -p udp --dport 13 -j LOG --log-prefix daytime
iptables -t filter -A FORWARD -i eth2 -o eth1 -d 100.211.0.50 -p udp --dport 13 -j ACCEPT

# Para este tipo de tráfico configura además reglas/s con acción LOG para que
# cada vez que se permita el tráfico UDP descrito anteriormente, se deje un 
# mensaje en el fichero de LOG del sistema.

# PREGUNTA 6

# Permite únicamente la comunicación entre la red privada y la zona DMZ de la
# siguiente forma:

# Acceso desde pc1 a un servidor de echo (TCP, puerto 7) existente en pc4.
iptables -t filter -A FORWARD -i eth0 -o eth1 -d 100.211.0.40 -p tcp --dport 7 -j LOG --log-prefix tcp
iptables -t filter -A FORWARD -i eth0 -o eth1 -d 100.211.0.40 -p tcp --dport 7 -j ACCEPT

# Para este tipo de tráfico configura además reglas/s con acción LOG para que
# cada vez que se permita el tráfico UDP descrito anteriormente, se deje un 
# mensaje en el fichero de LOG del sistema.

# PREGUNTA 7

# No se debe permitir iniciar ninguna comunicación con la red privada ni con
# el propio firewall desde la zona DMZ.
iptables -t filter -A FORWARD -i eth1 -o eth0 -m state --state NEW -j DROP
iptables -t filter -A INPUT -i eth1 -m state --state NEW -j DROP
