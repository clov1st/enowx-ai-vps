FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl python3 python3-pip python3-venv \
    xvfb fonts-liberation libnss3 libatk-bridge2.0-0 libdrm2 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2 \
    libpango-1.0-0 libcairo2 libcups2 libxss1 libgtk-3-0 \
    libdbus-glib-1-2 wget jq procps lsof \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://api.enowxlabs.com/install/enowx-ai | bash

EXPOSE 1430 1431

VOLUME ["/root/.enowxai"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -sf http://localhost:1430/health || exit 1

ENTRYPOINT ["/root/.local/bin/enowxai"]
CMD ["__daemon"]
