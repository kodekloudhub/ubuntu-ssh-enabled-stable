FROM ubuntu:24.04

# Install OpenSSH server and any necessary dependencies
RUN apt-get update && apt-get install -y openssh-server && apt-get clean

# Create SSH run directory
RUN mkdir -p /var/run/sshd

# Set root password
RUN echo 'root:Passw0rd' | chpasswd

# Enable root login via SSH
RUN sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable password authentication
RUN sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Avoid being kicked off after login due to PAM
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Set environment variable to avoid some login issues
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
