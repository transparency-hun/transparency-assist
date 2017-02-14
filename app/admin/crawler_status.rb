# frozen_string_literal: true
require 'instance_manager'

ActiveAdmin.register_page 'Crawler Status' do
  content do
    running = InstanceManager.new.running?

    render partial: 'admin/crawler_status/show', locals: { running: running }
  end

  action_item :start_ec2 do
    link_to 'Start Crawler Machine', start_ec2_admin_crawlers_path
  end

  action_item :stop_ec2 do
    link_to 'Stop Crawler Machine', stop_ec2_admin_crawlers_path
  end

  action_item :start_all_crawlers do
    link_to 'Start All Crawlers', start_crawlers_admin_crawlers_path(crawler_type: 'all')
  end

  action_item :start_all_recent_crawlers do
    link_to "Start Crawlers of #{Time.zone.today.year}", start_crawlers_admin_crawlers_path(crawler_type: 'all_recent')
  end
end
