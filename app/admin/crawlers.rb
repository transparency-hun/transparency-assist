# frozen_string_literal: true
require 'instance_manager'
require 'crawler_manager'

ActiveAdmin.register Crawler do
  menu false

  actions :start_ec2, :stop_ec2, :start_crawlers

  collection_action :start_ec2, method: :get do
    Rails.logger.info InstanceManager.new.start
    redirect_to admin_crawler_status_path, notice: 'Crawler Machine is starting.. Please refresh to check status.'
  end

  collection_action :stop_ec2, method: :get do
    Rails.logger.info InstanceManager.new.stop
    redirect_to admin_crawler_status_path, notice: 'Crawler Machine is stopping.. Please refresh to check status.'
  end

  collection_action :start_crawlers, method: :get do
    InstanceManager.new.start
    sleep(5)

    debug = params[:debug].present?
    crawler_type = params[:crawler_type]
    year = params[:year]
    category = params[:category]

    CrawlerManager
      .new(debug: debug, crawler_type: crawler_type, year: year, category: category)
      .crawl

    redirect_to admin_crawler_status_path, notice: 'Crawlers are starting to gather data..'
  end
end
