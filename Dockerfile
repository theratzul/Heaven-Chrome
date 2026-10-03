# Production Dockerfile for Heaven Chrome Web
FROM nginx:alpine

LABEL maintainer="popa bogdan <theratzul>"
LABEL description="Heaven Chrome - Divine Time-Bending Action Adventure Web App"

# Copy custom Nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy web files
COPY web/ /usr/share/nginx/html/

# Expose HTTP
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
