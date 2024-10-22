# Stage 1: Build the Next.js app

# Use an official Node.js runtime as the base image
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json/yarn.lock to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Next.js app (production build)
RUN npm run build

# Stage 2: Serve the app with a production-ready server

# Use a smaller Node.js runtime for the final image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/node_modules ./node_modules

# Expose the port that the Next.js app will run on
EXPOSE 3000

# Set the environment to production
ENV NODE_ENV production

# Start the Next.js app
CMD ["npm", "run", "start"]
