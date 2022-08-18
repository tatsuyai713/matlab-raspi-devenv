FROM raspi_docker_image:latest

USER root

RUN mkdir -p /home/pi/.ssh
RUN chown -R pi:pi /home/pi
RUN echo 'pi:raspberry' | chpasswd
RUN usermod --shell /bin/bash pi && \
        usermod -aG sudo pi && \
        echo "pi ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
RUN apt-get update --allow-releaseinfo-change && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:raspberry' | chpasswd
RUN pwunconv
RUN pwconv

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 20022/' /etc/ssh/sshd_config

EXPOSE 20022
USER pi
CMD sudo bash -c 'ssh-keygen -A' && sudo bash -c '/usr/sbin/sshd -D &' && /bin/bash
