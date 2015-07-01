class Tweet 

	attr_reader :user, :text, :hashtags, :links, :created_at, :location

	def initialize(user, text, hashtags, links, created_at, location)
		@user = user
		@text = text
		@hashtags = hashtags
		@links = links
		@created_at = created_at
		@location = location
	end

end