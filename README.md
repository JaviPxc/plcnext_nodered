Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@JaviPxc 
JaviPxc
/
plcnext_nodered
1
00
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
Settings
plcnext_nodered/Instrucciones de instalacion.txt
@JaviPxc
JaviPxc Add files via upload
Latest commit 5cd4171 4 days ago
 History
 1 contributor
45 lines (37 sloc)  2.57 KB
  
###################
## PASOS PREVIOS ##
###################

1. Tener instalado en el PC un cliente SFTP. Por ejemplo, WinSCP.
2. Tener instalado en el PC un cliente SSH. Por ejemplo, Putty.


#######################################
## INSTALACION ULTIMA VERSION NODEJS ##
#######################################

OJO!: Instalar la última versión puede conllevar errores no controlados en el procedimiento de 
instalación debido a posibles nuevas dependecias de ciertas librerías.

- Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
- Copiar solamente el fichero *.sh (nodescript_v3.0.sh) a /opt/plcnext/
- En el PLCnext dar al fichero *.sh permisos de ejecución. Dos opciones:
  1. Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
  2. Desde Putty > Ejecutar comando "chmod 744 /opt/plcnext/nodescript_v3.0.sh"
- Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
- Cambiar al usuario root. Para ello, ejecutar el comando "su" (es necesario haberlo creado previamente).
- Ejecutar el comando "cd /opt/plcnext/"
- Ejecutar el fichero con "./nodescript_v3.0.sh". El proceso de instalación tiene dos opciones:
  1. "./nodescript_v3.0.sh 0" instalación reducida. Escoger si el PLCnext NO tiene tarjeta SD.
  2. "./nodescript_v3.0.sh 1" instalación completa. Escoger si el PLCnext tiene tarjeta SD.
- Fijarse en los mensajes que se van imprimiendo para ver si todo se ha instalado correctamente.

#######################################
## INSTALACION VERSION NODEJS 16.1.0 ##
#######################################

- Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
- Copiar el fichero *.sh (nodescript_v3.0.sh) y el fichero node-v16.1.0-linux-armv7l.tar.gz a /opt/plcnext/
- En el PLCnext dar al fichero *.sh permisos de ejecución. Dos opciones:
  1. Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
  2. Desde Putty > Ejecutar comando "chmod 744 /opt/plcnext/nodescript_v3.0.sh"
- Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
- Cambiar al usuario root. Para ello, ejecutar el comando "su" (es necesario haberlo creado previamente).
- Ejecutar el comando "cd /opt/plcnext/"
- Ejecutar el fichero con "./nodescript_v3.0.sh". El proceso de instalación tiene dos opciones:
  1. "./nodescript_v3.0.sh 0" instalación reducida. Escoger si el PLCnext NO tiene tarjeta SD.
  2. "./nodescript_v3.0.sh 1" instalación completa. Escoger si el PLCnext tiene tarjeta SD.
- Fijarse en los mensajes que se van imprimiendo para ver si todo se ha instalado correctamente.


