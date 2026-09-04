# TheAuditor - Database-First Static Analysis Platform
# Requires Python 3.14+ for PEP 649 (Deferred Annotation Evaluation)

FROM python:3.14-rc-slim

# Install Node.js for JavaScript/TypeScript extractor
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first for better caching
COPY pyproject.toml README.md ./
COPY theauditor/ ./theauditor/

# Install TheAuditor with all dependencies
RUN pip install --no-cache-dir -e .[all]

# Build the JavaScript/TypeScript extractor bundle
WORKDIR /app/theauditor/ast_extractors/javascript
RUN npm install && npm run build

WORKDIR /app

# Create volume mount point for target repositories
VOLUME ["/target"]

# Default working directory for analysis
WORKDIR /target

ENTRYPOINT ["aud"]
CMD ["--help"]
