#!/bin/sh
set -eu

# --- Configuration ---
# Default environment variables - these will be used if not set externally
SECRET_KEY_BASE="fiS3Kr/OCjzmMwJENVu2JHmTMh00y+T9IhJNpFUR8k9l0vAhpoRwVGwJZakN21ji6N"
DATABASE_URL="ecto://postgres:Pa55word@147.79.70.105:5431/elixment_prod"
PHX_HOST="aiworkshop.techkunstler.com"
# --- Helper Functions ---

# Function to perform a single step and validate
run_step() {
  local command="$1"
  local description="$2"
  echo "--- $description ---"
  echo "Executing: $command"
  eval "$command"
  local exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo "ERROR: Step failed with exit code $exit_code"
    exit $exit_code
  fi
  echo "--- $description --- Successfully completed."
}

# --- Script Start ---

echo "Starting script."

# --- 1. System Updates and Basic Configuration ---
run_step "Update system packages" 'Update system packages and enable firewall' "apt update && apt --yes upgrade && ufw --force enable"

# --- 2. Install Caddy ---

function install_caddy() {
  echo "Installing Caddy..."
  run_step "Install Caddy" 'Install Caddy' "apt install -y caddy debian-keyring debian-archive-keyring apt-transport-https"
  # Add Caddy repository
  run_step "Add Caddy repository" 'Add Caddy repository' "curl -fsSL 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
  apt update && apt --yes upgrade"
}

install_caddy


# --- 3. Install Elixir and Dependencies ---
echo "Installing Elixir, git, erlang...\n\n"
run_step "Install Elixir and Git" 'Install Elixir and Git' "add-apt-repository ppa:rabbitmq/rabbitmq-erlang && apt update && apt install git elixir erlang build-essential"

# --- 4. Install Phoenix RC.0 ---
run_step "Install Phoenix RC.0" 'Install Phoenix RC.0' "mix archive.install hex phx_new 1.8.0-rc.0 --force"


# --- 5. Environment Variable Setup ---
echo "Setting up environment variables..."
export SECRET_KEY_BASE="$SECRET_KEY_BASE"
export DATABASE_URL="$DATABASE_URL"
export PHX_HOST="$PHX_HOST"

# --- 6. Ecto Database Setup ---
run_step "Create Ecto Database" 'Create Ecto database' "MIX_ENV=prod mix ecto.create && MIX_ENV=prod mix ecto.migrate"

# --- 7. Docker Setup ---
echo "Setting up Docker..."

# Remove conflicting packages
run_step "Remove conflicting Docker packages" 'Remove conflicting Docker packages' "for pkg in docker.io docker-doc docker-compose podman-docker containerd.io docker-buildx-plugin docker-compose-plugin; do sudo apt-get remove $pkg; done"

# Add Docker GPG key
run_step "Add Docker GPG key" 'Add Docker GPG key' "sudo apt-get update && sudo apt-get install ca-certificates curl && sudo install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc"

# Add Docker repository
run_step "Add Docker repository" 'Add Docker repository' "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list && sudo apt-get update"

# Install Docker Engine
run_step "Install Docker Engine" 'Install Docker Engine' "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"


# --- 8. Docker Image Build and Run ---
run_step "Build and run Elixment Docker Image" 'Build and run Elixment Docker Image' "docker build . -t elixment:1.0 && docker run -d --name pg-prod -p 5431:5432 -e POSTGRES_USER=produser -e POSTGRES_PASSWORD=prodpassword postgres:16 && docker inspect pg-prod"

# --- 9. Docker Image Build and Run (Elixment) ---
run_step "Build and run Elixment Docker Image" 'Build and run Elixment Docker Image' "docker build . -t elixment:1.0 && docker run -d --name elixment -p 3000:3000 -e DATABASE_URL=$DATABASE_URL -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e PHX_HOST=$PHX_HOST elixment:1.0"


# --- 10. Script Complete ---
echo "Script complete! Rebooting..."
reboot
