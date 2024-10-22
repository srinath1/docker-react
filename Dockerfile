# Stage 1: Build React application
FROM node:14.17.0 as build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json ./

# Install dependencies using npm
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application using npm
RUN npm run build

# Stage 2: Setup Nginx and host the built React application
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built artifacts from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 (default HTTP port)
EXPOSE 80

# CMD for nginx (already set in nginx image)
CMD ["nginx", "-g", "daemon off;"]