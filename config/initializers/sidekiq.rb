Sidekiq.configure_server do |config|
  case Rails.env
  when 'production' then
    config.redis = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
  else
    config.redis = { url: 'redis://localhost:6379', namespace: 'sidekiq' }
  end
end

Sidekiq.configure_client do |config|
  case Rails.env
  when 'production' then
    config.redis = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
  else
    config.redis = { url: 'redis://localhost:6379', namespace: 'sidekiq' }
  end
end
