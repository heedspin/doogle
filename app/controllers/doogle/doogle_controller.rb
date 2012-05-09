require 'menu_selected'

class Doogle::DoogleController < ApplicationController
  filter_access_to :all
  include MenuSelected
end