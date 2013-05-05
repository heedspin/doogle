namespace :doogle do
  desc "Export the master list xls file."
  task :export_master_list => :environment do
    export = Doogle::MasterListExport.new
    destination_file = File.join(Rails.root, export.xls_filename)
    export.to_xls(destination_file)
    puts "Wrote #{destination_file}"
  end
end