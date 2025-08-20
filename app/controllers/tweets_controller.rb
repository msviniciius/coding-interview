class TweetsController < ApplicationController
  def index
    tweets_scope = Tweet.order(created_at: :desc)
    
    if params[:cursor]
      tweets_scope = tweets_scope.where('id < ?', params[:cursor])
    end

    @tweets = tweets_scope.limit(10)

    last_tweet = @tweets.last
    remaining_tweets = Tweet.where('id < ?', last_tweet.id).exists? if last_tweet
    @next_cursor = last_tweet.id if remaining_tweets
  end
end
