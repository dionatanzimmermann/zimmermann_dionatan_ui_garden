# Start your image with a node base image
FROM node:20-alpine AS builder

# The /zimmermann_dionatan_ui_garden directory should act as the main application directory
WORKDIR /zimmermann_dionatan_ui_garden

# Copy the app package and package-lock.json file
COPY package*.json ./

# Copy local directories to the current local directory of our docker image (/app)
COPY . .

# Install node packages, install serve, build the app, and remove dependencies at the end
RUN npm install \
    && npm install -g serve \
    && npm run build \
    && rm -fr node_modules

# Start the stage 2 with another node base image
FROM node:20-alpine

# The /zimmermann_dionatan_ui_garden directory should act as the main application directory
WORKDIR /zimmermann_dionatan_ui_garden

# Copy build output to working dir
COPY --from=builder /zimmermann_dionatan_ui_garden/build ./build

# Install serve, build the app
RUN npm install -g serve

# Build Storybook
#RUN npm run build-storybook

# Expose port
EXPOSE 8083

# Start the app using serve command
CMD [ "serve", "-s", "build", "-l", "8083"]

# Serve Storybook on port 8083
#CMD ["http-server", "storybook-static", "-p", "8083", "-a", "0.0.0.0"]