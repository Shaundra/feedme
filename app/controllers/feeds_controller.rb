class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :update, :refresh, :settings, :update_settings]

  def index
    if !@current_user
      redirect_to login_path
    else
      @feeds = @current_user.feeds
    end
  end

  def show
    @entries = @feed.entries.order(published_datetime: :desc)
  end

  def new
    @feed = Feed.search(params[:search])
  end

  def create
    @feed = Feed.find_or_create_by(feed_params)
    @new_feed = FeedSubscription.find_or_create_by(user: @current_user, feed: @feed)

    feed_entries = Entry.write_new_entries(Feed.fetch_and_parse_feed(@feed.feed_url))

    redirect_to feed_path(@feed)
  end

  def update
    @new_feed = FeedSubscription.find_or_create_by(user: @current_user, feed: @feed)

    redirect_to feed_path(@feed)
  end

  def refresh
    @feed.refresh_feed

    redirect_to feed_path(@feed)
  end

  def settings
  end

  def update_settings
    @current_user.update_or_create_feed_cats(feed_params)
    redirect_to feed_path(@feed)
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(
      :title,
      :url,
      :description,
      :search,
      :feed_url,
      :id,
      feed_category_ids: [],
      feed_categories: [:title]
    )
  end

end
