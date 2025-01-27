#!/bin/bash


#Step 2: Install the engine (latest version)
sudo apt-get update
sudo apt-get install docker.io

#Step 3: Execute docker without typing sudo every time.
sudo groupadd docker
sudo usermod -aG docker $USER


