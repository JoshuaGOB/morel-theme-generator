#!/bin/bash

# Check if repository is empty
if [ -z "$(ls -A /app/repository)" ]; then
    # If no files, clone the repository if URL is provided
    if [ -n "$GITHUB_REPO_URL" ]; then
        echo "Cloning repository from $GITHUB_REPO_URL"
        git clone "$GITHUB_REPO_URL" /app/repository
    else
        echo "No repository URL provided and no existing files found."
    fi
else
    echo "Repository directory is not empty. Using existing files."
fi

# Change to repository directory
cd /app/repository

# Install Ruby dependencies
if [ -f "Gemfile" ]; then
    echo "Installing Ruby dependencies..."
    bundle install
else
    echo "No Gemfile found. Installing Jekyll directly..."
    gem install jekyll webrick
fi

# Install Python dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Execute the command passed to the container
exec "$@"