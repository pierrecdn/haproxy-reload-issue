FROM debian

# Simple way to get 1.6.9
RUN echo "Install HAProxy" && \
    echo "deb http://httpredir.debian.org/debian sid main" | tee /etc/apt/sources.list.d/sid.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y haproxy && \
    apt-get clean

# Add the launch script and define it as the entrypoint with default values
ADD start.sh /start.sh
RUN chmod +x /start.sh
ADD haproxy.cfg /haproxy.cfg

ENTRYPOINT [ "/bin/bash", "/start.sh" ]
CMD [ "300", "0.002" ]
