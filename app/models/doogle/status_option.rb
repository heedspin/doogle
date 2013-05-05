require 'plutolib/active_hash_methods'
class Doogle::StatusOption < ActiveHash::Base
  self.data = [
    {:id => 1, :name => "#{Doogle::Status.draft.name} & #{Doogle::Status.published.name}", :cmethod => 'draft_and_published', :status_ids => [Doogle::Status.draft.id, Doogle::Status.published.id]},
    {:id => 2, :name => Doogle::Status.draft.name, :status_ids => [Doogle::Status.draft.id]},
    {:id => 3, :name => Doogle::Status.published.name, :status_ids => [Doogle::Status.published.id]},
    {:id => 4, :name => Doogle::Status.deleted.name, :status_ids => [Doogle::Status.deleted.id]},
    {:id => 5, :name => 'Any', :status_ids => Doogle::Status.all.map(&:id)}
  ]
  include Plutolib::ActiveHashMethods
end
