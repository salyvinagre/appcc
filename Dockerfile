# Global args
ARG PYTHON_VERSION=3.10
ARG MKDOCS=appcc

# Builder stage
FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-bookworm-slim AS builder

# Re-declare the ARG to use it in this stage
ARG DOCS_PATH

# hadolint ignore=DL3008
RUN <<EOF
    apt-get update
    apt-get install --no-install-recommends -y git build-essential
EOF

# Set uv environment variables
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

WORKDIR /
# Install the application dependencies and build .venv:
# for rootless configurations like podman, add 'z' or relabel=shared
# to circumvent the SELinux context
#
# See https://github.com/hadolint/language-docker/issues/95 for hadolint support
RUN --mount=type=cache,target=/root/.cache/uv                           \
    --mount=type=bind,source=uv.lock,target=uv.lock,ro                  \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml,ro    \
    --mount=type=bind,source=docs/appcc/mkdocs.yml,target=mkdocs.yml,ro \
    --mount=type=bind,source=docs/appcc/src,target=/src,ro              \
    echo"build doc at $(date)" && uv run --all-extras --frozen mkdocs build

# Copy generated html files to the /site directory
COPY docs/appcc/site .

# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Defalt environment variables
ENV NGINX_PORT=8080
ENV NGINX_HOST=localhost
ENV NGINX_ROOT=

# Create Nginx configuration template
RUN <<EOS

    mkdir -p /etc/nginx/templates
    cat > /etc/nginx/templates/default.conf.template << 'EOF'

server {
    listen ${NGINX_PORT};
    server_name ${NGINX_HOST};

    location ${NGINX_ROOT}/metrics {
        stub_status on;
    }
    location ${NGINX_ROOT}/ {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ =404;
    }
    error_page   500 502 503 504  ${NGINX_ROOT}/50x.html;
    location = ${NGINX_ROOT}/50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
EOS

# Copy the built site from the builder stage
COPY --from=builder /site /usr/share/nginx/html
