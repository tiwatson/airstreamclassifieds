desc 'Check airstream classifieds'
task :cron do
  Product.mark_removed
  Product.sync_active_external_ids
end
