release: bundle exec rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e $RACK_ENV -C config/sidekiq.yml
