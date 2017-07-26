module IshManager
  class ApplicationController < ActionController::Base
    protect_from_forgery :with => :exception
    before_action :set_current_ability
    check_authorization

    def home
      authorize! :home, Manager
      render 'home'
    end

    private

    def set_current_ability
      @current_ability ||= ::IshManager::Ability.new( current_user )
    end

    def set_lists
      @sites_list = Site.all.list
      @cities_list = City.all.list
      @venues_list = Venue.all.list
      @reports_list = Report.all.list
      @galleries_list = Gallery.all.list
      @videos_list = Video.all.list
      @user_profiles_list = IshModels::UserProfile.all.list
      @tags_list = Tag.all.list
    end

    private

    def pp_errors err
      err
    end

  end
end
