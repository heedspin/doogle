require 'menu_selected'

# declarative_authorization calls hide_action, which doesn't exist
# in Rails 5. So, monkeypatch it for Rails 5. It also immediately inserts itself
# into ActionController::Base when it's require'd, so we must monkeypatch
# ActionController::Base before require-ing it.
class ActionController::Base
  before_filter :filter_access_filter

  def self.hide_action(*names)
    if Rails::VERSION::MAJOR >= 5
      send(:private, *names)
    else
      super
    end
  end

  # Define it so that declarative_authorization can skip it
  def self.filter_access_filter
  end
end

require 'declarative_authorization'

class Doogle::DoogleController < ApplicationController
  filter_access_to :all
  include MenuSelected
  include Authorization::AuthorizationInController
  helper Authorization::AuthorizationHelper
end
