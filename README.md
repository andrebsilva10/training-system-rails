# README

This README documents the steps necessary to get the Rails 8 authentication example application up and running.

## Ruby version

- Ruby 3.1.0

## System dependencies

- Rails 8.0.0
- Bundler

## Configuration

1. Clone the repository.
2. Run `bundle install` to install dependencies.

## Database creation

Run the following command to create the database:

```sh
rails db:create
```

## Features

### Public page

- Home page with hero section

### Authentication

- User registration with email confirmation.
- User login and logout.
- Password reset functionality.

### User Dashboard

- Edit profile information.
- Update avatar.
- Change password.

### Routes

- `/` - Root page with hero section
- `/signup` - User registration
- `/login` - User login
- `/logout` - User logout
- `/password/new` - Request password reset
- `/password/edit` - Reset password
- `/users/profile/edit` - Edit profile
- `/users/profile/edit_password` - Change password
- `/users/profile/update_avatar` - Update avatar