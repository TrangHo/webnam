# fix for old fog version compatibility
module Excon
 class Connection
   VALID_CONNECTION_KEYS << :url
 end
end

Refinery::Images.configure do |config|
  # Configures the maximum allowed upload size (in bytes) for an image
#  config.max_image_size = 102400
  config.max_image_size = 819200

  # Configure how many images per page should be displayed when a dialog is presented that contains images
  # config.pages_per_dialog = 18

  # Configure how many images per page should be displayed when a dialog is presented that
  # contains images and image resize options
  # config.pages_per_dialog_that_have_size_options = 12

  # Configure how many images per page should be displayed in the list of images in the admin area
  # config.pages_per_admin_index = 20

  # Configure image sizes
  # config.user_image_sizes = {:small=>"110x110>", :medium=>"225x255>", :large=>"450x450>"}

  # Configure image view options
  # config.image_views = [:grid, :list]

  # Configure default image view
  # config.preferred_image_view = :grid

  # Configure S3 (you can also use ENV for this)
  # The s3_backend setting by default defers to the core setting for this but can be set just for images.
  config.s3_backend = Refinery::Core.s3_backend
  config.s3_bucket_name = ENV['S3_BUCKET']
  config.s3_access_key_id = ENV['S3_KEY']
  config.s3_secret_access_key = ENV['S3_SECRET']
  config.s3_region = ENV['S3_REGION']

  # Configure Dragonfly
  # This is where in the middleware stack to insert the Dragonfly middleware
  # config.dragonfly_insert_before = "ActionDispatch::Callbacks"
  # config.dragonfly_secret = "1f87fd50a658ddaf1783637e77d8b7a3754c2aa34288c1d2"
  # If you decide to trust file extensions replace :ext below with :format
  # config.dragonfly_url_format = "/system/images/:job/:basename.:ext"
  # config.datastore_root_path = "c:/projects/webnam21/public/system/refinery/images"
  # config.trust_file_extensions = false

end
