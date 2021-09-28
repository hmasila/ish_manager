
ENV["RAILS_ENV"] ||= 'test'
# require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require File.expand_path("../../config/environment.rb", __FILE__)
require 'rspec/rails'
require 'devise'

RSpec.configure do |config|

  ## 20210205
  config.include Rails.application.routes.url_helpers
  config.include Warden::Test::Helpers
  Warden.test_mode!


  config.infer_spec_type_from_file_location!

  # config.include Devise::TestHelpers, :type => :helper
  # config.include Devise::TestHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :controller

end

# @TODO: remove this, right?
class UserStub
  def initialize args = {}
    @profile = OpenStruct.new :role_name => :guy, :friends => []
    if args[:manager]
      @profile[:manager?] = true
      @profile[:sudoer?] = true
      @profile[:role_name] = :admin
    end
    if args[:sudoer]
      @profile[:sudoer?] = true
    end
  end

  def profile= profile
    @profile = profile
  end

  def profile
    return @profile
  end

  def email
    return 'some@email.com'
  end

  def id
    return 1
  end

end

def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

def do_setup
  setup_users

  Report.unscoped.destroy_all
  @report = FactoryGirl.create :report

  ::Gameui::PremiumPurchase.unscoped.destroy_all
  @purchase = FactoryGirl.create :purchase, item: @report, user_profile: @profile
end

def setup_profiles
  emails = %w( one@gmail.com two@gmail.com three@gmail.com )
  @profiles = {}
  IshModels::UserProfile.all.destroy
  emails.each_with_index do |email, index|
    u = FactoryGirl.create :user, :email => email
    p = FactoryGirl.create :user_profile, :email => email, :user => u, :name => 'some-name'
    @profiles[index] = p
  end
end

def setup_reports
  Report.all.destroy
  @report = FactoryGirl.create :report
end

def setup_tags
  Report.all.destroy
  @report = FactoryGirl.create( :report, :name => rand(1000), :name_seo => rand(1000) )

  Tag.all.destroy
  @tag = FactoryGirl.create :tag
  @tag.reports << @report
  @tag.save
end

def setup_users
  User.all.destroy
  IshModels::UserProfile.all.destroy
  @user    = FactoryGirl.create :user, :email => 'piousbox@gmail.com'
  @profile = FactoryGirl.create :user_profile, :email => 'piousbox@gmail.com', role_name: 'manager', user: @user
  @profile.save && @profile.reload
  @user.save && @user.reload
  @user_1  = FactoryGirl.create :user, :email => 'user-1@gmail.com'
  @user_2  = FactoryGirl.create :user, :email => 'user-2@gmail.com'
  sign_in @user, :scope => :user
  # allow(controller).to receive(:current_user).and_return(UserStub.new(:manager => true ))
end

Paperclip.options[:log] = false
