# Use an official Ubuntu base image as a starting point
# We'll use a recent LTS version for stability
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
# We'll need these for Ruby, Jekyll, Python, and general development
RUN apt-get update && apt-get install -y \
    # Essential build tools
    build-essential \
    # Version control
    git \
    # Ruby dependencies
    autoconf \
    bison \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    # Python dependencies
    python3 \
    python3-pip \
    python3-venv \
    # Additional utilities
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby using rbenv for version management
# This allows more flexibility in Ruby version installation
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && export PATH="$HOME/.rbenv/bin:$PATH" \
    && eval "$(~/.rbenv/bin/rbenv init -)" \
    && rbenv install 3.3.3 \
    && rbenv global 3.3.3

# Update PATH to include Ruby and rbenv
ENV PATH="/root/.rbenv/shims:/root/.rbenv/bin:${PATH}"

# Verify Ruby installation
RUN ruby --version

# Install Jekyll and other Ruby gems
RUN gem install jekyll bundler

# Optional: Create a Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Clone the GitHub repository
# Replace REPOSITORY_URL with the actual GitHub repository URL
ARG GITHUB_REPO_URL
RUN if [ -z "$GITHUB_REPO_URL" ]; then \
        echo "Error: No repository URL provided. Use --build-arg GITHUB_REPO_URL=<your-repo-url>"; \
        exit 1; \
    fi \
    && git clone $GITHUB_REPO_URL /app/repository

# Set the final working directory to the cloned repository
WORKDIR /app/repository

# Optional: Install Python dependencies if a requirements.txt exists
RUN if [ -f "requirements.txt" ]; then \
        pip install -r requirements.txt; \
    fi

# Default command (can be overridden)
CMD ["/bin/bash"]
