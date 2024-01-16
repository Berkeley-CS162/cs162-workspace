# 🫘 CS162 Workspace 🫘

## Introduction

Welcome to the CS162 Workspace, a Docker-based environment for CS 162! This image is designed to provide a standardized development environment for students regardless of host architecture or OS, without the hassle of VPN'ing into an instructional machine.

## Prerequisites
Docker is a cross-platform tool for managing containers. You can use Docker to download and run the Workspace we have prepared for this course. The Workspace for the course may undergo significant changes every term; do not use one from a previous semester.

First, you will have to download and install Docker to your machine so you can access the Workspace. This can be done in one of following two ways.

- **(Preferred)** Download the Docker Desktop app from the [Docker website](https://docs.docker.com/desktop/).
- **(or)** download both the [Docker Engine](https://docs.docker.com/engine/) and [Docker Compose](https://docs.docker.com/compose/)

## Getting Started
Lucky for you, we have already built the image for both ARM and x86 machines (hosted on [Docker Hub](https://hub.docker.com/r/cs162/pintospace))!

After Docker has been installed, type the following into your terminal to initalize the Docker Workspace and begin an SSH session. These commands will download our Docker Workspace from our server and launch it. The download of the Workspace will take some time and requires an Internet connection.

_Note: Docker commands will generally have to be run with sudo access, so for the commands below you might need to use `sudo docker-compose up -d`._

1. **Clone this GitHub Repository**
  
2. **Navigate to the Repository**
   ```bash
   cd cs162-workspace
   ```

3. **Run Docker Compose for the first time**
   ```bash
   docker-compose up
   ```

   This command will build and start the Docker container defined in the `docker-compose.yml` file. If needed, you can change the port used for SSH within this file.

   Wait until you see "Docker workspace is ready!" in the terminal. The Workspace is now ready (obviously 🙄).
   
   Use <kbd>Ctrl</kbd> + <kbd>C</kbd> to stop the command.

4. **Starting the container in the background**
   ```bash
   docker-compose up -d
   ```
   This will simply start the container in the background and keep it running. With Docker Desktop, you can also manage this through the GUI.

5. **SSH into the Container**
   ```bash
   ssh workspace@127.0.0.1 -p 16222
   ```

   Use the password `workspace` the first time you SSH into the container.
  
6. **Stop the container**
   ```bash
   docker-compose down
   ```
   This will stop the container. Your data should still be saved within the hidden `.workspace` folder, so you can restart the container as needed and pick up where you left off.

   **Note: To be safe, always push work you want to keep to Github!**
   
   **Use with caution:** If you ever need it, you can use `sudo rm -rf .workspace` to reset the Workspace. 

## Avoiding Password Entry

To avoid entering the password every time you SSH into the container, follow these additional steps from your host machine:

1. **Copy Your SSH Key**
   ```bash
   ssh-copy-id -p 16222 -i ~/.ssh/id_ed25519.pub workspace@127.0.0.1
   ```

   Replace `~/.ssh/id_ed25519.pub` with the path to your SSH public key.

2. **Update SSH Config**
   To alias the full SSH command, add the following lines to your `~/.ssh/config` file:
   ```
   Host docker162
     HostName 127.0.0.1
     Port 16222
     User workspace
     IdentityFile ~/.ssh/id_ed25519
   ```
You can now enjoy a passwordless SSH experience for your CS162 workspace:
`ssh docker162`

Happy coding!

## Updating the image

You may need to update the image if changes are pushed. You could completely reset your workspace by deleting the .workspace directory. However, we provide a mechanism to safely update by tracking changes with git.

1. To be extra safe, **push anything you want to keep to Github first**.

2. Pull the latest image from Docker hub with `docker image pull cs162/pintospace`.

3. Stop and remove the old container. You can do this through the Docker desktop GUI or the command line via `docker stop CONTAINER_ID && docker rm CONTAINER_ID`. You can find your `CONTAINER_ID` through `docker ps -a`. 

4. Run `docker-compose run -i cs162` and follow the instructions to update. You can exit out of the shell with `exit` once it's done.
   
5. You're done updating! You can go back to the usual way of starting the container.

## Building From Source (OPTIONAL and not recommended)

**Local build:**

Simply run `docker build .`

**For staff:**

If you would like to deploy changes to Docker Hub for ARM and x86, first sign in with the `cs162` account and run the following buildx command:

`docker buildx build --platform linux/amd64,linux/arm64  -t cs162/pintospace:latest --push .`
