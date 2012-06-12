require 'active_hash_methods'
class Doogle::StatusOption < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Draft & Published', :cmethod => 'draft_and_published', :status_ids => [Doogle::Status.draft.id, Doogle::Status.published.id]},
    {:id => 2, :name => 'Draft', :status_ids => [Doogle::Status.draft.id]},
    {:id => 3, :name => 'Published', :status_ids => [Doogle::Status.published.id]},
    {:id => 4, :name => 'Deleted', :status_ids => [Doogle::Status.deleted.id]},
    {:id => 5, :name => 'Any', :status_ids => Doogle::Status.all.map(&:id)}
  ]
  include ActiveHashMethods
end
