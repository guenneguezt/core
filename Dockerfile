FROM debian:latest

MAINTAINER info@jeedom.com

ENV SHELL_ROOT_PASSWORD Mjeedom96

RUN apt-get update && apt-get install -y \
wget \
openssh-server \
supervisor \
usb-modeswitch \
python-serial \
htop \
net-tools \
python \
vim \
git \
g++ \
mysql-client \
usbutils \
iputils-ping

RUN echo "root:${SHELL_ROOT_PASSWORD}" | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN rm /etc/motd
ADD install/motd /etc/motd
RUN rm /root/.bashrc
ADD install/bashrc /root/.bashrc
ADD install/OS_specific/Docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD install/install.sh /root/install_docker.sh
RUN /root/install_docker.sh -s 1;exit 0
RUN /root/install_docker.sh -s 2;exit 0
RUN /root/install_docker.sh -s 4;exit 0
RUN /root/install_docker.sh -s 5;exit 0
RUN /root/install_docker.sh -s 7;exit 0
RUN /root/install_docker.sh -s 10;exit 0

ADD install/OS_specific/Docker/init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]

EXPOSE 22 80
