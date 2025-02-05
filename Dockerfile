FROM ghcr.io/fluttercommunity/flutter:latest AS build

# Set working directory inside the container
WORKDIR /app

# Copy Flutter project files
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build Flutter Web app
RUN flutter build web --release

# Use Nginx as a lightweight web server
FROM nginx:alpine

# Copy the built web app to Nginx’s default HTML directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
