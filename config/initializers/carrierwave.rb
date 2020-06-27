require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? #本番環境であれば、AWSを使用する！
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'yupimarufurima1'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/yupimarufurima1'
  else
    config.storage :file # 開発環境であれば、public/uploades下に保存する！
    config.enable_processing = false if Rails.env.test? #testの時は、処理をスキップ！
  end
end