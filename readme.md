````markdown
# NGINX Healthcheck Docker Image

This project provides a custom NGINX Docker image that periodically checks HTTP connectivity to a list of FQDNs (fully qualified domain names). If any of the domains are unreachable on the specified HTTP port, the container automatically reloads or restarts NGINX.

## Features

- Lightweight image based on `nginx:latest`
- Installs `curl` and `ping` tools
- Supports external list of domains via volume
- Performs periodic HTTP port check
- Reloads NGINX automatically if connectivity fails

## Project Structure

.
├── Dockerfile              # Dockerfile to build custom image  
├── check-http.sh           # Bash script for health checking  
├── domain/domains.txt             # Example domain list (to be mounted)  
└── README.md               # This documentation


## Build the Image

```bash
docker build -t nginx-healthcheck .
````

## Run the Container

```bash
docker run -d \
  -v $(pwd)/domains:/etc/nginx/domain \
  -p 8080:80 \
  --name nginx-healthcheck \
  nginx-healthcheck
```

* Access NGINX via: [http://localhost:8080](http://localhost:8080)
* Domains in `domains.txt` will be checked every 30 seconds

## domains.txt Format

Provide one FQDN per line:

```
example.com
anotherdomain.com
internal.service.local
```

You can mount your own file when starting the container.

## Environment Variables (Optional)

| Variable     | Description                  | Default                |
| ------------ | ---------------------------- | ---------------------- |
| PORT         | Port to check on each domain | 80                     |
| DOMAIN\_FILE | Path to domain list file     | /etc/nginx/domains.txt |

## License

MIT License


