
require 'net/http'


class HomeController < ApplicationController

	def index
		@tweets = [] 
		t = Tweet.new "fjborie","Aloha",["copa","america"],["google","facebook"],"4/5/2015", [-30.342,-70.321]
		@tweets << t
	end

	def fetch_tweets
		type = params[:type]
		quote = params[:quote]
		response = request_tweets(type,quote)
		@tweets = extract_tweets_from_response(response)
		respond_to do |format|
			format.js
		end
	end

	private 

	def request_tweets(type,quote)
		url = nil
		if type == 'near'
			quote = quote.split(';')
			url = URI.parse('http://search.bd.rbw.cl/'+type+'?lat='+quote[0]+'&lon='+quote[1]+'&radius='+quote[2])
		else
			url = URI.parse('http://search.bd.rbw.cl/'+type+'?q='+quote)
		end
		request = Net::HTTP::Get.new(url.to_s)
		response = Net::HTTP.start(url.host, url.port) { |http|
			http.request(request)
		}
		return response
	end

	def extract_tweets_from_response(response)
		tweets = []
		json_tweets = JSON.parse(response.body)
		json_tweets.each do |tweet|
			tweets << extract_tweet_from_json(tweet)
		end
		return tweets
	end

	def extract_tweet_from_json(tweet)
		user = tweet['user']
		text = tweet['status']
		created_at = tweet['createdAt']

		hashtags = tweet['hashtags']
		links = tweet['links']
		location = tweet['location']
		return Tweet.new user,text, hashtags, links, created_at, location
	end
end
