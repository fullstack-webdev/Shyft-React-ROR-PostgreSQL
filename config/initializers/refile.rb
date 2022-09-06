require "refile/s3"

aws = {
	region: ENV['AWS_REGION'],
	bucket: ENV['AWS_BUCKET_NAME'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY:'],
}
Refile.cache = Refile::S3.new(prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)

Refile::MiniMagick.prepend Module.new {
	[:limit, :fit, :fill, :pad].each do |action|
		define_method(action) do |img, *args|
			super(img, *args)
			auto_orient(img)
		end
	end

	def auto_orient(img)
		img.tap(&:auto_orient)
		img = yield(img) if block_given?
		img
	end
}
