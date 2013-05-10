desc 'Check airstream classifieds'
task :cron => :environment do
  Product.mark_removed
  Product.sync_active_external_ids
end
