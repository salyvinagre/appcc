#!/usr/bin/env bash
set -e

echo "Installing UV..."

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Define the URL for the UV installation script
UV_INSTALL_URL="https://astral.sh/uv"
if [ "${VERSION:-"latest"}" != "latest" ]; then
    UV_INSTALL_URL="https://astral.sh/uv/${VERSION}"
fi

# Download the UV installation script
curl -LsSf "$UV_INSTALL_URL/install.sh" -o /tmp/install_uv.sh

# Make the script executable
chmod +x /tmp/install_uv.sh

# Execute the script and evaluate the result
env UV_INSTALL_DIR="/usr/local" /tmp/install_uv.sh

echo "UV installation completed."
