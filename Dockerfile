
FROM ubuntu:24.04

# Evitar preguntas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar paquetes e instalar SSH, sudo y herramientas necesarias
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Crear el usuario ansible con contraseña ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

# Permitir que ansible use sudo sin contraseña
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Preparar el directorio del servidor SSH
RUN mkdir -p /var/run/sshd

# Permitir autenticación mediante contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config

# Exponer el puerto SSH
EXPOSE 22

# Iniciar el servidor SSH en primer plano
CMD ["/usr/sbin/sshd", "-D"]
