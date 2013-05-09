# 02 10 * * * /var/www/lxdhub/script/runner.sh 'Sales::SalesReportRunner.new.run_in_background!(:update_nightly)'
namespace :doogle do
  desc "Export the master list xls file."
  task :export_master_list => :environment do
    export = Doogle::MasterListExport.new
    basedir = Rails.env.development? ? Rails.root : '/home/tim/Dropbox/Sales'
    destination_file = File.join(basedir, export.xls_filename)
    export.to_xls(destination_file)
    puts "Wrote #{destination_file}"
  end
end