
# PASOS PREVIOS
1. Tener instalado en el PC un __cliente SFTP__. Por ejemplo, [WinSCP](https://winscp.net/eng/download.php).
2. Tener instalado en el PC un __cliente SSH__. Por ejemplo, [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).
3. Tener el __PLCnext conectado a internet__.
4. Haber creado en el __PLCnext un usuario root__. [Setting_a_root_user_password](https://www.plcnext.help/te/Operating_System/Root_rights.htm#Setting_a_root_user_password)


# DESCARGA Y USO
1. Descargar los ficheros del repositorio al PC. Disponibles en: https://github.com/JaviPxc/plcnext_nodered/archive/refs/heads/main.zip
2. Descomprimir el fichero zip descargado.
3. El script principal es __nodescript.sh__, el cual permite hacer los siguientes tipos de instalación de Nodered:
   * Sobre un PLCnext con o sin tarjeta SD.
   * Descargar automáticamente la última versión de Nodejs o instalar una versión concreta dada por el usuario. 
4. En función del tipo de instalación que desee realizar, deberá seguir los pasos correspondientes descritos a continuación.


## OP.1: INSTALACION ULTIMA VERSION NODEJS
OJO!: Instalar la última versión puede conllevar errores no controlados en el procedimiento de 
instalación debido a posibles nuevas dependecias de ciertas librerías.

1. Haber descargado el contenido del repositorio (punto anterior).
2. Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
3. Copiar los ficheros _nodescript.sh_ y _start_nodered_ a _/opt/plcnext/_
4. En el PLCnext dar al fichero _nodescript.sh permisos de ejecución_. Dos opciones:
   - Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
   - Desde Putty > Ejecutar comando ```chmod 744 /opt/plcnext/nodescript.sh```
5. Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
6. Cambiar al usuario root. Para ello, ejecutar el comando ```su``` (necesario haberlo creado previamente).
7. Ejecutar el comando ```cd /opt/plcnext/``` y luego ```./nodescript.sh```. 
8. El script mostrará un menú con las distintas opciones. Pasar los parámetros adecuados en función de la instalación a realizar.
   - Por ejemplo: ```cd /opt/plcnext/``` y luego ```./nodescript.sh 1 0``` para instalar la última versión en un PLCnext con tarjeta SD.
9. El proceso de instalación es prácticamente automático al 100%. Fijarse en los mensajes que se van imprimiendo por pantalla para ver si todo se ha instalado correctamente o ver donde consultar el error que ha sucedido.


## OP.2: INSTALACION VERSION NODEJS ESPECIFICA
1. Haber descargado el contenido del repositorio (punto anterior).
2. Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
3. Copiar los ficheros _nodescript.sh_ y _start_nodered_ a _/opt/plcnext/_
4. En el PLCnext dar al fichero _nodescript.sh permisos de ejecución_. Dos opciones:
   - Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
   - Desde Putty > Ejecutar comando ```chmod 744 /opt/plcnext/nodescript.sh```
5. Descargar al PC la versión específica de Nodejs que se desea instalar. Se puede descargar de https://nodejs.org/dist. De toda la lista de versiones disponibles, se ha de seleccionar el fichero correspondiente a la plataforma de PLCnext (los que tienen un nombre como _node-{VERSION}-linux-armv7l.tar.gz_)
6. Copiar el fichero _node-{VERSION}-linux-armv7l.tar.gz_ a _/opt/plcnext/_. 
7. Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
8. Cambiar al usuario root. Para ello, ejecutar el comando ```su``` (necesario haberlo creado previamente).
9. Ejecutar el comando ```cd /opt/plcnext/``` y luego ```./nodescript.sh```. 
10. El script mostrará un menú con las distintas opciones. Pasar los parámetros adecuados en función de la instalación a realizar.
   - Por ejemplo: ```cd /opt/plcnext/``` y luego ```./nodescript.sh 1 1``` para instalar una versión específica en un PLCnext con tarjeta SD.
11. El proceso de instalación es prácticamente automático al 100%. Fijarse en los mensajes que se van imprimiendo por pantalla para ver si todo se ha instalado correctamente o ver donde consultar el error que ha sucedido.

## OP.3: OTROS PAQUETES INSTALABLES DESDE EL SCRIPT
### INSTALACION LIBRERIA 'LIBATOMIC' (SOLO NECESARIA SI FALLA EL PROCESO DE INSTALACIÓN)
1. Haber descargado el contenido del repositorio (punto anterior).
2. Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
3. Copiar los ficheros _nodescript.sh_ y _libatomic.zip_ a _/opt/plcnext/_
4. En el PLCnext dar al fichero _nodescript.sh permisos de ejecución_. Dos opciones:
   - Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
   - Desde Putty > Ejecutar comando ```chmod 744 /opt/plcnext/nodescript.sh```
5. Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
6. Cambiar al usuario root. Para ello, ejecutar el comando ```su``` (necesario haberlo creado previamente).
7. Ejecutar el comando ```cd /opt/plcnext/``` y luego ```./nodescript.sh```. 
8. El script mostrará un menú con las distintas opciones. Pasar los parámetros adecuados en función de la instalación a realizar.
   - Por ejemplo: ```cd /opt/plcnext/``` y luego ```./nodescript.sh 2``` para instalar la librería libatomic.
9. El proceso de instalación es prácticamente automático al 100%. Fijarse en los mensajes que se van imprimiendo por pantalla para ver si todo se ha instalado correctamente o ver donde consultar el error que ha sucedido.


### GENERAR CERFITICADO PARA NODE OPCUA (SOLO NECESARIO SI NO HAY CERTIFICADO OPCUA EN NODERED)
1. Haber descargado el contenido del repositorio (punto anterior).
2. Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
3. Copiar el fichero _nodescript.sh_ a _/opt/plcnext/_
4. En el PLCnext dar al fichero _nodescript.sh permisos de ejecución_. Dos opciones:
   - Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
   - Desde Putty > Ejecutar comando ```chmod 744 /opt/plcnext/nodescript.sh```
5. Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
6. Cambiar al usuario root. Para ello, ejecutar el comando ```su``` (necesario haberlo creado previamente).
7. Ejecutar el comando ```cd /opt/plcnext/``` y luego ```./nodescript.sh```. 
8. El script mostrará un menú con las distintas opciones. Pasar los parámetros adecuados en función de la instalación a realizar.
   - Por ejemplo: ```cd /opt/plcnext/``` y luego ```./nodescript.sh 3``` para generar un nuevo certificado.
   - Seguir las instrucciones solicitadas en pantalla para generar el certificado.
   - Una vez generado moverlo al directorio deseado.
9. El proceso de instalación es prácticamente automático al 100%. Fijarse en los mensajes que se van imprimiendo por pantalla para ver si todo se ha instalado correctamente o ver donde consultar el error que ha sucedido.
