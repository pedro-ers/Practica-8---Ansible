# Práctica de Ansible con Docker

## Descripción

Este proyecto consiste en implementar un entorno de automatización utilizando **Ansible y Docker**. Se crean cinco servidores virtuales basados en Ubuntu mediante contenedores Docker, que posteriormente son administrados de forma centralizada por Ansible desde Ubuntu en WSL.

El objetivo es automatizar tareas de administración y configuración en los cinco servidores sin tener que ejecutarlas manualmente en cada uno.

## Tecnologías utilizadas

- **Docker:** creación y ejecución de los servidores.
- **Docker Compose:** administración de los cinco contenedores.
- **Ubuntu 24.04:** sistema operativo de los servidores.
- **WSL2:** entorno Linux utilizado desde Windows.
- **Ansible:** automatización y configuración de los servidores.
- **OpenSSH:** comunicación remota mediante SSH.

## Estructura del proyecto

```text
Practica-Ansible/
│
├── Dockerfile
├── docker-compose.yml
├── inventario.ini
├── ansible.cfg
│
└── playbooks/
    └── configuracion.yml
```

## Configuración del entorno

### 1. Construcción de la imagen Docker

Se utiliza un Dockerfile basado en Ubuntu 24.04 que instala:

- Servidor OpenSSH.
- Sudo.
- Python 3.
- Usuario `ansible` con contraseña para la conexión SSH.
- Permisos para ejecutar comandos administrativos mediante sudo sin solicitar contraseña.

Para construir la imagen:

```bash
docker build -t ubuntu-ansible:latest .
```

### 2. Creación de los servidores

Se utiliza Docker Compose para levantar cinco contenedores independientes:

| Servidor | Puerto SSH |
|---|---:|
| servidor1 | 2221 |
| servidor2 | 2222 |
| servidor3 | 2223 |
| servidor4 | 2224 |
| servidor5 | 2225 |

Para iniciar los servidores:

```bash
docker compose up -d
```

Para comprobar que están activos:

```bash
docker ps
```

### 3. Instalación de Ansible

Ansible se instala dentro de Ubuntu en WSL2.

```bash
sudo apt update
sudo apt install ansible sshpass -y
```

Para comprobar la instalación:

```bash
ansible --version
```

### 4. Configuración del inventario

El archivo `inventario.ini` contiene la información de conexión SSH de los cinco servidores, incluyendo sus direcciones, puertos y credenciales de acceso.

El archivo `ansible.cfg` establece el inventario que utilizará Ansible y desactiva la comprobación de claves de host para este entorno de laboratorio.

### 5. Comprobación de conectividad

Antes de ejecutar las tareas de configuración, se comprueba la conexión con los servidores:

```bash
ansible servidores -m ping
```

La respuesta esperada es `SUCCESS` con `ping: pong` para cada uno de los cinco servidores.

## Automatización mediante Ansible

El playbook `playbooks/configuracion.yml` ejecuta las siguientes tareas en todos los servidores:

1. **Actualizar el caché de APT:** actualiza el índice de paquetes del sistema operativo.
2. **Crear el usuario `itla`:** crea un usuario con su directorio personal y shell Bash.
3. **Crear la carpeta `app`:** crea el directorio `/home/ansible/app`.
4. **Crear el archivo `hola.txt`:** genera un archivo dentro de la carpeta `app`, con un mensaje que identifica al servidor correspondiente.
5. **Instalar programas:** instala los paquetes `cowsay` y `htop`.

Para ejecutar el playbook:

```bash
ansible-playbook playbooks/configuracion.yml
```

## Verificación de resultados

Se utilizaron comandos de Ansible para comprobar que las tareas se ejecutaron correctamente.

**Verificar la existencia del usuario:**

```bash
ansible servidores -m command -a "id itla"
```

**Comprobar el contenido del archivo:**

```bash
ansible servidores -m command -a "cat /home/ansible/app/hola.txt"
```

**Verificar los programas instalados:**

```bash
ansible servidores -m shell -a "command -v cowsay && command -v htop"
```

## Resultados obtenidos

La práctica se ejecutó satisfactoriamente en los cinco servidores.

- Los cinco servidores respondieron correctamente a las pruebas de conectividad.
- El usuario `itla` fue creado en cada servidor.
- Se creó la carpeta `app` y el archivo `hola.txt`.
- Se instalaron correctamente `cowsay` y `htop`.
- El playbook finalizó sin servidores inaccesibles ni tareas fallidas (`failed=0`).

## Autor

Práctica académica de automatización y administración de servidores utilizando Ansible y Docker.