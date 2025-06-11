# Use Node.js 18 Alpine for smaller image size
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache git python3 make g++

# Copy package files
COPY package.json yarn.lock ./
COPY apps/backend/package.json ./apps/backend/

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy source code
COPY . .

# Setup backend environment
WORKDIR /app/apps/backend
RUN cp .env.template .env

# Build the application
WORKDIR /app
RUN yarn build || yarn turbo build || (cd apps/backend && yarn build)

# Generate necessary files
WORKDIR /app/apps/backend
RUN yarn generate:oas || echo "OAS generation skipped"

# Expose the port
EXPOSE 9000

# Set working directory to backend for runtime
WORKDIR /app/apps/backend

# Start command
CMD ["yarn", "start"]
