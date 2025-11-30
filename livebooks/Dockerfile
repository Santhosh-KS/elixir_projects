FROM ghcr.io/livebook-dev/livebook:0.17.2

# Apps configuration
ENV LIVEBOOK_APPS_PATH="/apps"
ENV LIVEBOOK_APPS_PATH_WARMUP="manual"

# Notebook
COPY myapp.livemd /apps/

# Cache apps setup at build time
RUN /app/bin/warmup_apps
