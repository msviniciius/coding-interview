class TweetsController < ApplicationController
  def index
    @tweets = Tweet.order(created_at: :desc)
    @tweets = @tweets.where(user_id: params[:user_id]) if params[:user_id].present?

    if params[:company_id].present?
      @tweets = @tweets.where('created_at >= ?', Time.at(params[:cursor].to_i))
    end

    @tweets = @tweets.limit(10)
  end
end
