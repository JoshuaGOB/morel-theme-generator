# Use the official Jekyll image as the base
FROM jekyll/jekyll:4

# Set the working directory inside the container
WORKDIR /srv/jekyll

# Copy the current directory (your Jekyll project) into the container
COPY . .

# Install the project dependencies
RUN bundle install

# Expose port 4000 for Jekyll
EXPOSE 4000

# Command to run when the container starts
CMD ["jekyll", "serve", "--livereload", "--host", "0.0.0.0"]
