# Clear App

<insert description of the app here>

# Ruby Version

We use Ruby 3.4.1 for this project. To simplify development, we use a docker container with many dependencies pre-installed.

View lingfeishengtian/rails-postgres:latest on Docker Hub.

# System Dependencies

- Heroku
- PostgreSQL

# Configuration

- Create a `.env` file in the root directory of the project and add the following environment variables:
  - `GOOGLE_OAUTH_CLIENT_ID`
  - `GOOGLE_OAUTH_CLIENT_SECRET`
  - `GOOGLE_OAUTH_REDIRECT_URI`
  - `DEV_EMAIL`: Configure this email to the developer's email which allows them some overrides just in case of emergencies.

# Database Creation

- Run `rails db:create` to create the database.
- Run `rails db:migrate` to apply migrations.
- Run `rails db:seed` to seed the database with initial data.

# Database Initialization

- Ensure the `.env` file is properly configured with the required environment variables.
- Use `rails db:setup` to create, migrate, and seed the database in one step.

# How to Run the Test Suite

- Run `rspec` to execute the test suite.
- Ensure all tests pass before deploying changes.

# Deployment Instructions

- The app is deployed on Heroku. Use the Heroku CLI to manage deployments.
- Run `git push heroku main` to deploy the latest changes.
- Ensure all environment variables are configured in the Heroku dashboard.

# Additional Notes

- The app uses Docker for development. Run `docker-compose up` to start the development environment.
- For production, ensure all dependencies are installed and configured properly.

