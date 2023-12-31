# Dockerfile for NoVNC + Websockify

## Target 'setup'
FROM debian:latest AS setup

## Update and Upgrade package repositories and install dependencies
RUN apt update -y && apt upgrade -y && \
    apt install -y bash x11vnc novnc websockify xauth xvfb xorg

## Target 'server'
FROM setup AS server

## Set Build-time Arguments
## - To invoke and specify: `docker build --build-arg [ARGUMENT_VARIABLE]=[ARGUMENT_VALUE]`
ARG VNC_SERVER_PASS=
ARG FRAMEBUFFER_SCREEN_SPECS="-screen 0 1024x768x16"

## Set Run-time Environment Variables
## - To invoke and specify: `[ENVIRONMENT_VARIABLE]=[VALUE] docker build`

### DISPLAY virtual monitor number used for Graphical application rendering by the display server (Xorg/Wayland)
ENV DISPLAY=:0

### Framebuffer
ENV FRAMEBUFFER_OPTS="${DISPLAY} ${FRAMEBUFFER_SCREEN_SPECS}"

### VNC server
ENV VNC_SERVER_HOST=127.0.0.1
ENV VNC_SERVER_PORT=5900
ENV VNC_SERVER_OPTS="-display ${DISPLAY} -rfbport ${VNC_SERVER_PORT} -usepw -passwd ${VNC_SERVER_PASS} -xkb -forever -shared"

### Websocket server
ENV WEBSOCKET_CLIENT_PATH=/usr/share/novnc
ENV WEBSOCKET_SERVER_PORT=6080

## Set current working directory

## Generate Xorg server authority file
RUN touch -- $HOME/.Xauthority && \
    chmod u+x $HOME/.Xauthority && \
    xauth add "${DISPLAY}" MIT-MAGIC-COOKIE-1 "$(od -An -N16 -tx /dev/urandom | tr -d ' ')" 

## Networking
### Specify ports to expose
#### 6080 = WebSocket server port
#### 5900 = VNC server
# EXPOSE 6080 
# EXPOSE 5900

## Set Entry point command
## Startup Xorg Virtual Framebuffer to allow drawing/rendering of Graphical Applications within the background as a process
ENTRYPOINT Xvfb ${FRAMEBUFFER_OPTS} & { \
    ## Startup VNC server within the Virtual Framebuffer environment and websocket server to point to Web/Browser-based VNC client \
    websockify -D --web=${WEBSOCKET_CLIENT_PATH} ${WEBSOCKET_SERVER_PORT} ${VNC_SERVER_HOST}:${VNC_SERVER_PORT}; \
    x11vnc ${VNC_SERVER_OPTS}; \
}

