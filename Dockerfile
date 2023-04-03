# syntax=docker/dockerfile:1

FROM ubuntu:22.04
WORKDIR /root

# install miniconda3
RUN --mount=type=bind,source=miniconda3.tar.gz,target=miniconda3.tar.gz \
    tar zxf ./miniconda3.tar.gz
RUN echo 'export PATH="/root/miniconda3/bin:$PATH"' >>./.bashrc

# install openssh package
RUN apt update || true
RUN apt install -y openssh-server openssh-client
RUN apt install -y net-tools vim

# configure sshd
RUN mkdir -p /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN ["usermod","-p","$6$ujIkM5cm1it4wQdS$Ma64iYRVeJ25S3KgAYt7XVeuT56KOY55nMAc/svk1W7wm20qgbxQ7hPH0cCORk9wVEZGqC/GlnJ7WG2TBLvfU1","root"]

# mount point in container
RUN mkdir /root/ai-tmp

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd","-D"]
