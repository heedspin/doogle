class Doogle::SearchVendors
  def self.all
    results = Doogle::Display.connection.select_rows <<-SQL
    select vendor_name, m2m_vendor_id
    from display_prices
    group by vendor_name, m2m_vendor_id
    order by vendor_name
    SQL
    results.each do |row|
      if row[1].blank?
        row[1] = row[0]
      end
    end
    results
  end
end