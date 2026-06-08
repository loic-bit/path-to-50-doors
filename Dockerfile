FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
# Railway injects $PORT — replace nginx default 80 with it at startup
CMD sh -c "sed -i 's/listen  *80/listen '\"$PORT\"'/' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
