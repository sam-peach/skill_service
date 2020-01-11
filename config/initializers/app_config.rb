unless Rails.env.production?
  ENV['MONOLITH_URL'] = "http://localhost:3000/microservices"
end