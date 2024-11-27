# Use an official Ubuntu base image as a starting point
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
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
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby using rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && export PATH="$HOME/.rbenv/bin:$PATH" \
    && eval "$(~/.rbenv/bin/rbenv init -)" \
    && rbenv install 3.3.5 \
    && rbenv global 3.3.5

# Update PATH to include Ruby and rbenv
ENV PATH="/root/.rbenv/shims:/root/.rbenv/bin:${PATH}"

# Upgrade RubyGems and Bundler
RUN gem update --system && \
    gem install bundler

# Create a Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Create an entrypoint script to handle repository and dependencies
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]
