threads(8, 32)
port(ENV.fetch("PORT") { 3000 })
environment(ENV.fetch("RAILS_ENV") { "development" })
