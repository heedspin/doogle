if Rails::VERSION::MAJOR < 5
  require 'menu_selected'
  require 'declarative_authorization'

  class Doogle::DoogleController < ApplicationController
    filter_access_to :all
    include MenuSelected
    include Authorization::AuthorizationInController
    helper Authorization::AuthorizationHelper
  end
end
