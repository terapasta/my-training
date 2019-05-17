def use_s3?
  ENV['S3_ACCESS_KEY'] && ENV['S3_SECRET_KEY'] && ENV['S3_REGION'] && ENV['S3_BUCKET']
end

if use_s3?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      :provider              => 'AWS',
      :region                => ENV['S3_REGION'],
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end
