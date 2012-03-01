class Doogle::Status < ActiveHash::Base
  DRAFT='Draft'
  DRAFT_ID=1
  PUBLISHED='Published'
  PUBLISHED_ID=2
  DELETED='Deleted'
  DELETED_ID=3
  self.data = [
      {:id => DRAFT_ID,     :name => DRAFT},
      {:id => PUBLISHED_ID, :name => PUBLISHED},
      {:id => DELETED_ID,   :name => DELETED}
    ]
    
  def self.deleted
    find_by_name(DELETED)
  end
  
  def self.published
    find_by_name(PUBLISHED)
  end
  
  def self.draft
    find_by_name(DRAFT)
  end
  
  def deleted?
    self.id == DELETED_ID
  end
  
  def draft?
    self.id == DRAFT_ID
  end
  
  def published?
    self.id == PUBLISHED_ID
  end
  
  def to_s
    name
  end
end