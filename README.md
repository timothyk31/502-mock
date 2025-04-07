# Clear App

## Project Description
A modern web application built with Ruby on Rails and PostgreSQL. The app provides an easy way to manage members, events, and transcations. It includes features like user authentication, event management, and transaction tracking within the originating organization.
The app is designed to be user-friendly and efficient, making it suitable for both small and large organizations.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Testing](#testing)
- [Deployment](#deployment)
- [Dependencies](#dependencies)
- [License](#license)
- [Contact](#contact)

## Requirements
This code has been run and tested with the following components:

### Environment
- Docker Engine (latest)
- Heroku (latest)
- Node.js (v16+ recommended)
- Yarn (latest)

### Program
- Ruby 3.4.1
- Rails 7.0.8
- PostgreSQL (latest)
- RSpec 5.0

### Tools
- GitHub
- RuboCop 1.17.2
- Heroku CLI
- Docker Desktop

## Installation

### Using Docker (Recommended)
```bash
cd clear-app
docker run -it --volume "${PWD}:/directory" -e DATABASE_USER=admin -e DATABASE_PASSWORD={pswd} -p 3000:3000 lingfeishengtian/rails-postgres:latest
```

### Manual Installation
```bash
git clone (https://github.com/lingfeishengtian/502-mock.git)
cd clear-app
bundle install
yarn install
```

## Configuration
Create a `.env` file in the root directory with the following variables:
```
GOOGLE_OAUTH_CLIENT_ID=your_client_id
GOOGLE_OAUTH_CLIENT_SECRET=your_client_secret
GOOGLE_OAUTH_REDIRECT_URI=your_redirect_uri
DEV_EMAIL=your@email.com
```

## Database Setup
Run the following commands to set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```
Or for a complete setup:
```bash
rails db:setup
```

## Testing
Run the test suite with:
```bash
rspec
```

## Deployment
The app is deployed on Heroku. To deploy:

1. Ensure all changes are committed.
2. Push to Heroku:
    ```bash
    git push heroku main
    ```
3. Run migrations if needed:
    ```bash
    heroku run rails db:migrate
    ```

## Dependencies

### External Dependencies
- Docker
- Heroku CLI
- Git

### Third-Party Libraries
- **rails_icons**: MIT License  
- **kaminari**: MIT License  
- **mini_magick**: MIT License  
- **cocoon**: MIT License  

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contact
For questions or support, please contact:
- Hunter Han
- [Project GitHub Issues](#)
