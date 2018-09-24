class HomeController < ApplicationController
  def index
  	@user = params[:search_user]

  	if @user

  		# Gets user data in JSON
		require 'net/http'
		require 'json'
		url = 'https://www.instagram.com/'+@user+'/?hl=en'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		doc = Nokogiri::HTML(response)
		script = doc.css('script')
		script = script.to_s
		startstring = "window._sharedData"
		endstring = ";</script>"
		@json_data = script[/#{startstring}(.*?)#{endstring}/m, 1].gsub("=", "")
		#@y = ActiveSupport::JSON.decode(@x)

		# Get profile image
		# https://chunksofco.de/neatly-dealing-with-json-parse-d-hashes-in-ruby-6a99d1740288
		json_parse = JSON.parse(@json_data)
		@img_user = json_parse['entry_data']['ProfilePage'][0]['graphql']['user']['profile_pic_url']

		# Get last 3 images
		@imgs_user = ""
		(0..2).each do |i|
			@imgs_user += json_parse['entry_data']['ProfilePage'][0]['graphql']['user']['edge_owner_to_timeline_media']['edges'][i]['node']['display_url'] + ", "
		end
		@imgs_user = @imgs_user.split(",")
		print @imgs_user
	end
  end
end
