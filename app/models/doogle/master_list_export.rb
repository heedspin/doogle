require 'plutolib/to_xls'

class Doogle::MasterListExport
  include Plutolib::ToXls
  
  def xls_filename
    "LXD_Master_List.xls"
  end
  
  def xls_each_sheet(&block)
    [['tft_displays', 'TFTs'], ['oled_displays', 'OLED Graph'], ['oled_character_modules', 'OLED Char'], ['segment_glass_displays', 'Segment Glass'], ['graphic_glass_displays', 'Graphic Glass'], ['graphic_module_displays', 'Graphic Modules'], ['character_module_displays', 'Character Module'], ['accessories', 'Accessories'], ['shutter', 'Shutters']].each do |type_key, sheet_name|
      display_type = Doogle::DisplayConfig.find_by_key(type_key)
      fields = display_type.master_list_fields.map do |field|
        if field.search_vendor?
          Plutolib::ToXls::Field.new('Vendor') do |d|
            if vendor = d.preferred_vendor
              vendor.short_name
            else
              field.render(d, :format => :xls) 
            end
          end
        else
          format = field.attachment? ? Spreadsheet::Format.new(:color => :blue) : nil
          Plutolib::ToXls::Field.new(field.name, format) do |d| 
            field.render(d, :format => :xls) 
          end
        end
      end
      fields.push(Plutolib::ToXls::Field.new('Demos') { |d| 
        d.demo_items.map { |i| "#{i.part_number} #{i.quantity_on_hand.to_i}" }.join(', ')
      })
      fields.push(Plutolib::ToXls::Field.new('On Hand', self.xls_no_decimals_format) { |d| d.item.try(:quantity_on_hand) })
      fields.push(Plutolib::ToXls::Field.new('Available', self.xls_no_decimals_format) { |d| d.item.try(:quantity_available)})
      fields.push(Plutolib::ToXls::Field.new('Last Quote', self.xls_date_format) { |d| d.logs.log_type(Doogle::LogType.quote).by_date_desc.first.try(:event_time).try(:to_date) })
      fields.push(Plutolib::ToXls::Field.new('Quotes') { |d| 
        logs = d.logs.log_type(Doogle::LogType.quote).includes(:quote)
        logs.map { |l| l.quote.try(:customer_name) }.compact.uniq.sort.join(', ')
      })
      fields.push(Plutolib::ToXls::Field.new('Last Shipped', self.xls_date_format) { |d|
        if d.item
          # Need _with_duplicates to get sort to work correctly.
          M2m::Shipper.for_item_with_duplicates(d.item).by_ship_date_desc.first.try(:ship_date).try(:to_date)
        else
          nil
        end
      })
      fields.push(Plutolib::ToXls::Field.new('Customers') { |d| 
        d.sync_to_erp!
        if d.item
          result = M2m::SalesOrder.connection.select_rows <<-SQL
            select distinct(somast.fcompany)
            from soitem 
            left join somast on soitem.fsono = somast.fsono
          where soitem.fpartno = N'#{d.item.part_number}'
          SQL
          result.map do |row| 
            Iconv.iconv('utf-8', 'latin1', row.first.strip).first.titleize
          end.sort.join(', ')
        else
          nil
        end
      })
      fields.push(Plutolib::ToXls::Field.new('Price Notes') { |d| d.preferred_vendor_price.try(:notes) })
      fields.push(Plutolib::ToXls::Field.new('Price Updated', self.xls_date_format) { |d| d.preferred_vendor_price.try(:updated_at) })
      (1..Doogle::DisplayPrice::TOTAL_LEVELS).each do |level|
        fields.push(Plutolib::ToXls::Field.new("Price Level #{level}") { |d|
          if d.preferred_vendor_price and (price_level = d.preferred_vendor_price.levels[level-1]) and price_level.cost
            "#{price_level.quantity}: " + sprintf('$%.2f', price_level.cost)
          else
            nil
          end
        })
      end
      
      displays = Doogle::Display.not_deleted.display_type(display_type).on_master_list.by_model_number
      yield(sheet_name, fields, displays)
    end
  end
end
