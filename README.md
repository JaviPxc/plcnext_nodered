
# PASOS PREVIOS

1. Tener instalado en el PC un __cliente SFTP__. Por ejemplo, WinSCP.
2. Tener instalado en el PC un __cliente SSH__. Por ejemplo, Putty.
3. Tener el __PLCnext conectado a internet__.
4. Haber creado en el __PLCnext un usuario root__. https://www.plcnext.help/te/Operating_System/Root_rights.htm#Setting_a_root_user_password


# DESCARGA Y USO

1. Descargar los ficheros del repositorio al PC. Disponibles en: https://github.com/JaviPxc/plcnext_nodered/archive/refs/heads/main.zip
2. Descomprimir el fichero zip descargado.
3. El script principal es __nodescript.sh__. Básicamente permite diferenciar entre una instalación de Nodered para:
   * PLCnext con o sin tarjeta SD.
   * Descarga de la última versión de Nodejs o de una versión concreta dada por el usuario. 
4. En función del tipo de instalación que desee realizar, deberá seguir los pasos correspondientes descritos a continuación.


## INSTALACION ULTIMA VERSION NODEJS

OJO!: Instalar la última versión puede conllevar errores no controlados en el procedimiento de 
instalación debido a posibles nuevas dependecias de ciertas librerías.

1. Haber descargado el contenido del repositorio (punto anterior).
2. Conectarse al PLCnext por SFTP (por ejemplo, con WinSCP).
3. Copiar solamente el fichero _nodescript.sh_ a _/opt/plcnext/_
4. En el PLCnext dar al fichero _nodescript.sh permisos de ejecución_. Dos opciones:
   - Desde WinSCP > Botón derecho sobre el fichero > Propiedades > Marcar columna 'x'
   - Desde Putty > Ejecutar comando ```chmod 744 /opt/plcnext/nodescript_v3.0.sh```
5. Conectarse al PLCnext por SSH como admin (por ejemplo, con Putty).
6. Cambiar al usuario root. Para ello, ejecutar el comando ```su``` (necesario haberlo creado previamente).
7. Ejecutar el comando ```./opt/plcnext/nodescript_v3.0.sh```. 
8. El script mostrará un menú con las distintas opciones. Pasar los parámetros adecuados en función de la instalación a realizar.
   - Por ejemplo: ```./opt/plcnext/nodescript_v3.0.sh 1 0``` para instalar la última versión en un PLCnext con tarjeta SD.
9. El proceso de instlación es prácticamente automático al 100%. Fijarse en los mensajes que se van imprimiendo por pantalla para ver si todo se ha instalado correctamente o ver donde consultar el error que ha sucedido.


## INSTALACION VERSION NODEJS 16.1.0

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

## INSTALACION LIBRERIA 'LIBATOMIC' REQUERIDA POR npm


## GENERAR CERFITICADO PARA NODE OPCUA

