FROM nginx:latest

FROM nginx:stable

# Install curl and ping
RUN apt-get update && \
    apt-get install -y curl iputils-ping && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy health check script
COPY check-http.sh /usr/local/bin/check-http.sh
RUN chmod +x /usr/local/bin/check-http.sh

RUN mkdir /etc/nginx/domain
# Start NGINX in background, run loop for check in foreground
CMD ["sh", "-c", "/usr/sbin/nginx && while true; do /usr/local/bin/check-http.sh; sleep 30; done"]
