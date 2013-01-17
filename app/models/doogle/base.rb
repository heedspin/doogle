require 'active_hash'

class Doogle::Base < ApplicationModel
  self.abstract_class = true
  extend ActiveHash::Associations::ActiveRecordExtensions
end