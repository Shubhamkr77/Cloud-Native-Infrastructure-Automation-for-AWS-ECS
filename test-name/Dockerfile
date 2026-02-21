# Simple test app for ECS
FROM nginx:alpine

# Create a simple index page
RUN echo '<html><body><h1>Hello from ECS on EC2!</h1><p>Environment: DEV</p><p>This is a test container running on ECS cluster.</p></body></html>' > /usr/share/nginx/html/index.html

# Expose port 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

