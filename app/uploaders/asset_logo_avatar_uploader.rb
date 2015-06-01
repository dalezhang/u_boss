# encoding: utf-8

class AssetLogoAvatarUploader < AvatarUploader


  include CarrierWave::MiniMagick

  process :resize_to_fit => [1000, 1000]
  version :thumb do
    process :resize_to_fill => [240,240]
  end

end

