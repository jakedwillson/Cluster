# Cluster

<tt>Cluster</tt> is a Rails web application for team project management. It allows developers to create teams and allocate tasks to each individual team member. The teampage represents the progress of each developer in a simple and elegant way. Tasks can be assigned deadlines, GitHub branches, and all future tasks are stored in a shared task queue.

## How to Setup the Application Locally

1. Install [Ubuntu](https://ubuntu.com/)
1. Install [RVM](https://rvm.io/rvm/install)
1. Run the following commands:

```
rvm install "ruby-2.5.1"
sudo apt install ruby-railties
gem install bundler
bundle
rails assets:clobber
rails db:drop db:create db:migrate db:seed
rails s
```

You should then be able to access the application by typing `localhost:3000` into a web browser.

## Known Issues

1. The Create Account feature for this application is currently broken and will need to be fixed in a future pull request. It was working as of December 2019, but broke somepoint thereafter. It appears on the surface that the issue is related to the SMTP aspect of the email communication, which previously served as a way to allow the user to confirm their account creation via email. In the meantime, I have implemented a workaround (in welcome_controller.rb) such that whenever a person hits the homepage of this application, they will automatically be logged in as the first user in the database.

## Author

Jake Willson