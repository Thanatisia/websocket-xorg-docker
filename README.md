# Running Xorg Virtual Framebuffer, VNC Server, Websocket server and Web/browser-based VNC client from Docker

## Information
### Summary
```
Base VNC + WebSocket server docker image that aims to simplify the initial setup of a containerized Graphical environment
```

### Components
- x11vnc : VNC server
- websockify : WebSocket server
- novnc : Web/Browser-based VNC client
- Xorg : Display Server
    - xauth : Xorg Authorization CLI utility
    - Xvfb : Xorg Virtual Framebuffer; Used to create a virtual framebuffer in the memory to allow you to draw/render graphical applications in a virtual environment within the background as a process

### Operational Flow
- Image Build
    - Setup
        - Installs dependencies
        - Creates a brand new Xauthority cookie file in the HOME directory (default = root, /root)
        - Adds a randomly-generated number using the MAGIC-COOKIE-1 algorithm used by xauth into the xauth database
    - Entry Point
        - Set the DISPLAY environment variable that provides the virtual monitor display to be used by the DISPLAY server
        - Startup Virtual Framebuffer environment pointing to the 'DISPLAY' monitor number environment variable
        - Startup VNC server pointing to the Virtual Framebuffer environment variable and options
        - Startup Websocket server mapping the Websocket server's listening port to the VNC server's host address and port number

## Setup
### Dependencies
+ docker
+ docker-compose
+ git

### Pre-Requisites
- Select your base image
    - x11vnc (Recommended)
    - tigervncserver (aka xtigervnc)

### Build
- Build Docker image
    ```console
    docker build \
        -t thanatisia/websocket-X:latest \
        --build-arg VNC_SERVER_PASS=[VNC-server-password] \
        -f Dockerfile \
        .
    ```

### Startup
- Startup Docker container
    ```console
    docker run -itd \
        --name=browser-x \
        -p 6080:6080 \ # Websocket server port
        -p 5900:5900 \ # VNC server port
        thanatisia/websocket-X:latest
    ```

### Teardown
- Stop container
    ```console
    docker stop browser-x
    ```

- Remove container
    ```console
    docker rm browser-x
    ```

### Run all
- Using make script
    ```console
    ./make.sh
    ```

- Command Line
    ```console
    docker build -t thanatisia/websocket-X:latest --build-arg VNC_SERVER_PASS=[VNC-server-password] -f Dockerfile . && \
        docker stop browser-x && docker rm browser-x; \
        docker run -itd \
            --name=browser-x \
            -p 6080:6080 \
            -p 5900:5900 \
            thanatisia/websocket-X:latest
    ```

### Container use
- Enter container TTY
    ```console
    docker exec -it browser-x /bin/bash
    ```

### Implementation
- To use as a base image
    + Build the image
    - Include the following 
        - in your Dockerfile
            FROM thanatisia/browser-x:latest AS server:
        - in your docker-compose
            image: thanatisia/browser-x

## Documentations

### Build-time Arguments (Local Variables)
- To invoke and specify: `docker build --build-arg [ARGUMENT_VARIABLE]=[ARGUMENT_VALUE]`

#### Arguments
- FRAMEBUFFER_OPTS="[DISPLAY-monitor-number] -screen [monitor-number] [width]x[height]x[color-depth/bitrate]" : Set the X Virtual Framebuffer (Xvfb) startup options
    - Positionals
        - DISPLAY : Specify the $DISPLAY monitor number environment variable (i.e. :0, :1)
    - Options
        - screen
            + monitor-number : Specify the virtual monitor number to display the window; i.e. :0 = 0, :1 = 1
        - resolution
            + width : Specify the width (horizontal length) of the Virtual Framebuffer's canvas window (i.e. 1920)
            + height : Specify the height (vertical height) of the Virtual Framebuffer's canvas window (i.e. 1080)
            + color-depth/bitrate : Specify the color density of the Virtual Framebuffer's canvas window (i.e. 16-bit, 32-bit)
+ VNC_SERVER_PASS : Set the VNC server's password to use (Optional; Set '-nopw' in VNC_SERVER_OPTS to not use passwords)
- VNC_SERVER_OPTS="-display :0 -rfbport 5900 -usepw -passwd ${VNC_SERVER_PASS} -xkb -forever -shared" : Set the VNC server's options to startup with
    - Notes
        - '-bg' is not used to ensure that the ENTRY POINT has a foreground application to keep the container running
        - In the case where you would like to use '-bg', 
            + you can add 'bash' to the last application within the ENTRY POINT block

### Run-time Arguments (Environment Variables)
- To invoke and specify: `[ENVIRONMENT_VARIABLE]=[VALUE] docker build`

#### Arguments 
- System
    + `DISPLAY=:0` : DISPLAY virtual monitor number used for Graphical application rendering by the display server (Xorg/Wayland)
- VNC Server
    + `VNC_SERVER_HOST=127.0.0.1` : Set the VNC server's Hostname/IP address
    + `VNC_SERVER_PORT=5900`      : Set the VNC server's listening port number
    + `VNC_SERVER_PASS=[your-vnc-server-password]` : Set the VNC server's password
- Websocket server
    + `WEBSOCKET_CLIENT_PATH=/usr/share/novnc` : Set the Web/Browser-based VNC client you wish to access in the websocket server
    + `WEBSOCKET_SERVER_PORT=6080` : Set the WebSocket server's listening port number; This is the port number you access to view the Web/Browser-based VNC/SPICE client

### Dockerfiles
- x11vnc.Dockerfile : Recommended
    + Base Image: docker
    + Display Server: Xorg
    + VNC server: x11vnc
    + Websocket server: websockify

- xtigervnc.Dockerfile
    + Base Image: docker
    + Display Server: Xorg
    + VNC server: Xtigervnc (Package: tigervnc-standalone-server; aka tigervncserver)
    + Websocket server: websockify

### Networking
- Ports to expose
    + 5900 : Default VNC server listening port
    + 6080 : Default WebSocket server listening port

## Wiki

## Resources

## References

## Remarks

