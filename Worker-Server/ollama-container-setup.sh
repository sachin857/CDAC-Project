
## Install Docker

# Add Docker's official GPG key:
sudo apt-get update  # Update package list
sudo apt-get install ca-certificates curl  # Install necessary packages for HTTPS
sudo install -m 0755 -d /etc/apt/keyrings  # Create directory for Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc  # Download Docker's GPG key
sudo chmod a+r /etc/apt/keyrings/docker.asc  # Set appropriate permissions for the key

# Add Docker repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  # Add Docker repo to sources
sudo apt-get update  # Update package list with Docker repo

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin  # Install Docker components

## Setup NVIDIA repository

# Add NVIDIA's GPG key for the container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Add NVIDIA repository for container toolkit to Apt sources
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update package list and install NVIDIA container toolkit
sudo apt-get update  # Update package list with NVIDIA repo
sudo apt-get install -y nvidia-container-toolkit  # Install NVIDIA container toolkit

# Configure Docker to use NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=docker  # Configure NVIDIA container toolkit for Docker
sudo systemctl restart docker  # Restart Docker to apply changes

# Start the Ollama container with GPU support
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama  # Run Ollama container

# Run model locally
docker exec -it ollama ollama run llama3.1:latest  # Execute the Ollama model inside the container





