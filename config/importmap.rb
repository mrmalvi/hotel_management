# Pin npm packages by running ./bin/importmap

pin "application"

# config/importmap.rb
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
