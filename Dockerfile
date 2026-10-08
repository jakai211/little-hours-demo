FROM nginx:stable-alpine
ARG REVISION=local
LABEL org.opencontainers.image.source="https://github.com/jakai211/little-hours-demo"
COPY index.html /usr/share/nginx/html/index.html
RUN rm -f /usr/share/nginx/html/50x.html && printf '%s\n' "$REVISION" > /usr/share/nginx/html/version.txt
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
