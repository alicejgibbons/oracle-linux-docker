FROM oraclelinux:7-slim

# Web Site Home
WORKDIR /app

# Install Oracle client libraries
RUN yum -y install oracle-release-el7 oraclelinux-developer-release-el7 && \
    yum -y install python3 \
                   python3-libs \
                   python3-pip \
                   python3-setuptools \
                   python36-cx_Oracle && \
    rm -rf /var/cache/yum/*

# Copy the dependencies file to the working directory 
ADD requirements.txt /app
RUN pip3 install -r requirements.txt --no-cache-dir

# Add app code 
ADD . /app

# Expose app port here (update with your app port)
EXPOSE 5000 2222
ENV PORT 5000
ENV SSH_PORT 2222

# Set up SSH
ENV SSH_PASSWD "root:Docker!"
RUN yum install -y openssh openssh-server shadow-utils && yum clean all && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    mkdir /var/run/sshd 
RUN echo "$SSH_PASSWD" | chpasswd

COPY init.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/init.sh

# Invoke init.sh to start the SSH service and Python server
ENTRYPOINT ["init.sh"]