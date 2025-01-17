module IshManager
  class ApplicationController < ActionController::Base
    # protect_from_forgery :with => :exception, :prepend => true
    before_action :set_current_ability
    before_action :set_changelog
    check_authorization
    rescue_from ::CanCan::AccessDenied, :with => :access_denied

    def home
      authorize! :home, IshManager::Ability
      render 'home'
    end

    #
    # private
    #
    private

    def set_changelog
      @version = Gem.loaded_specs['ish_manager'].version.to_s
    end

    def set_current_ability
      @current_ability ||= ::IshManager::Ability.new( current_user )
    end

    def set_lists
      # alphabetized! : )
      @cities_list = City.list
      @galleries_list = Gallery.all.list
      @locations_list = ::Gameui::Map.list
      @maps_list = ::Gameui::Map.list
      @reports_list = Report.all.list
      @sites_list = Site.all.list
      @tags_list = Tag.list
      @user_profiles_list = Ish::UserProfile.all.list
      @venues_list = Venue.all.list
      @videos_list = Video.all.list
    end

    def access_denied exception
      store_location_for :user, request.path
      redirect_to user_signed_in? ? root_path : Rails.application.routes.url_helpers.new_user_session_path, :alert => exception.message
    end

    def pp_errors err
      err
    end

    def puts! a, b=''
      puts "+++ +++ #{b}"
      puts a.inspect
    end

    def update_profile_pic
      return unless params[:photo]
      @photo = Photo.new :photo => params[:photo]
      @photo.user_profile = @current_user.profile
      flag = @photo.save
      @resource.profile_photo = @photo
      flagg = @resource.save
      if flag && flagg
        flash[:notice] = 'Success'
      else
        flash[:alert] = "No Luck. #{@photo.errors.messages} #{@resource.errors.messages}"
      end
      # redirect_to resource_path( @resource )
    end

    def resource_path resource
      case resource.class.name
      when 'City'
        city_path( resource.id )
      when 'Event'
        event_path( resource.id )
      when 'Venue'
        venue_path( resource.id )
      end
    end

  end
end
