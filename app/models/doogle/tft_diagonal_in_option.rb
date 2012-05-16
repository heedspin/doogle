class Doogle::TftDiagonalInOption < ActiveHash::Base
  fields :id, :name
  
  def value
    self.id
  end
  
  def self.type_key
    'tft_displays'
  end
  
  # Doogle::TftDiagonalOption.all
  def self.all
    results = Doogle::Display.connection.select_rows <<-SQL
    select distinct(module_diagonal_in) as diagonal
    from displays 
    where status_id != #{Doogle::Status.deleted.id} 
    and type_key = '#{self.type_key}'
    SQL
    options = []
    results.each do |result_row|
      if (diagonal = result_row.first).present?
        options.push from_diagonal(diagonal)
      end
    end
    options
  end
  
  def self.from_diagonal(diagonal)
    return nil unless diagonal.present? 
    diagonal = diagonal.to_d
    new(:id => diagonal, :name => diagonal.to_s + '"')
  end
  
end
