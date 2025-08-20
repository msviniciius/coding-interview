# spec/controllers/tweets_controller_spec.rb
require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe "GET #index" do
    let!(:older_tweets) { create_list(:tweet, 5, created_at: 2.days.ago) }
    let!(:newer_tweets) { create_list(:tweet, 10, created_at: 1.day.ago) }

    context "sem cursor" do
      it "retorna os 10 tweets mais recentes e define next_cursor" do
        get :index

        expect(assigns(:tweets).count).to eq(10)
        expect(assigns(:tweets)).to all(satisfy { |t| t.created_at >= 2.days.ago })
        expect(assigns(:next_cursor)).to eq(assigns(:tweets).last.id)
      end
    end

    context "com cursor" do
      it "retorna os tweets anteriores ao cursor" do
        Tweet.delete_all

        older_tweets = create_list(:tweet, 5)
        newer_tweets = create_list(:tweet, 10)

        cursor = newer_tweets.first.id

        get :index, params: { cursor: cursor }

        tweets = assigns(:tweets)
        expect(tweets.count).to eq(5)
        expect(tweets).to match_array(older_tweets.sort_by(&:id).reverse)
      end
    end
  end
end
