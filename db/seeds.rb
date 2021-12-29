# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
    { username: "Admin", first_name: "John", last_name: "Doe", email: "admin@admin.com", password: "adminadmin", confirmed_at: Date.today, id: 1 },
    { username: "MichaelSmith", first_name: "Michael", last_name: "Smith", email: "michaelsmith@email.com", password: "adminadmin", confirmed_at: Date.today, id: 2 },
    { username: "JasonHunt", first_name: "Jason", last_name: "Hunt", email: "jasonhunt@email.com", password: "adminadmin", confirmed_at: Date.today, id: 3 },
    { username: "KellyDavis", first_name: "Kelly", last_name: "Davis", email: "kellydavis@email.com", password: "adminadmin", confirmed_at: Date.today, id: 4 },
    { username: "DanielThompson", first_name: "Daniel", last_name: "Thompson", email: "danielthompson@email.com", password: "adminadmin", confirmed_at: Date.today, id: 5 }
]

teams = [
    { name: 'CIS 501', description: "Client-Server desktop application", created_by: 1, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable" },
    { name: 'CIS 308', description: "Social media application", created_by: 1 },
    { name: 'Third Team', created_by: 2 },
    { name: 'Fourth Team', created_by: 2 },
    { name: 'Fifth Team', created_by: 2 }
]

team_users = [
    { team_id: 1, user_id: 1 },
    { team_id: 1, user_id: 2 },
    { team_id: 1, user_id: 3 },
    { team_id: 1, user_id: 4 },
    { team_id: 1, user_id: 5 },
    { team_id: 2, user_id: 1 }
]

tasks = [
    { team_id: 1, name: "Welcome page", deadline: Date.today + 3, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 },
    { team_id: 1, name: "Home page", deadline: Date.today + 4, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 },
    { team_id: 1, name: "DB Migrations", deadline: Date.today + 5, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 },
    { team_id: 1, name: "SMTP Server", deadline: Date.today + 5, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 },
    { team_id: 1, name: "Create Repo", deadline: Date.today + 1, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 },
    { team_id: 1, name: "README", deadline: Date.today + 2, github_url: "https://github.com/jakethesnnake/Cluster/tree/stable", status: 1 }
]

users.each { |user| User.create!(user) }
teams.each { |team| Team.create!(team) }
team_users.each { |team_user| TeamUser.create!(team_user) }
tasks.each { |task| Task.create!(task) }

def create_conversations(id1, id2)
  user1 = User.find_by_id(id1)
  user2 = User.find_by_id(id2)
  Conversation.find_or_create!(user1,user2)
end

conv1 = create_conversations(1,2)
conv2 = create_conversations(1,3)

conv1.add_message(User.first,"Can you finish the Welcome page by the end of the week?")
conv1.add_message(User.second,"Yes, I just need to finish the site logo")
conv1.add_message(User.first,"Let me know when you finish")
conv1.add_message(User.second,"Will do")

conv2.add_message(User.first,"Have you started the DB migrations")
conv2.add_message(User.find_by_id(3),"No, I'm only implementing the view with this pull request")
conv2.add_message(User.first,"Ok, just making sure we don't have merge conflicts")
conv2.add_message(User.find_by_id(3),"Gotcha")