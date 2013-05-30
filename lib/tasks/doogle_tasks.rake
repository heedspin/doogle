# 02 10 * * * cd /var/www/lxdhub ; bundle exec rake doogle:export_master_list
namespace :doogle do
  desc "Export the master list xls file."
  task :export_master_list => :environment do
    export = Doogle::MasterListExport.new
    basedir = Rails.env.development? ? Rails.root : AppConfig.sales_dropbox_root
    destination_file = File.join(basedir, export.xls_filename)
    export.to_xls(destination_file)
    puts "Wrote #{destination_file}"
  end
end