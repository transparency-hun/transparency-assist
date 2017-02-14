# frozen_string_literal: true
require 'kormany_hu_crawler'
require 'ksh_kao110_crawler'
require 'ksh_kao120_crawler'
require 'mvh_gov_hu_crawler'
require 'nka_crawler'
require 'instance_manager'

namespace :crawl do
  desc 'Crawl All'
  task all: [:environment] do
    Rake::Task['crawl:ksh_kao110'].invoke
    Rake::Task['crawl:ksh_kao120'].invoke

    Rake::Task['crawl:mvh_gov_hu'].invoke
    Rake::Task['crawl:nka'].invoke
    Rake::Task['crawl:kormany_hu'].invoke
    Rake::Task['crawl:kozbeszerzes'].invoke

    InstanceManager.new.stop
  end

  desc 'Crawl All Recent'
  task all_recent: [:environment] do
    current_year = Time.zone.today.year

    Rake::Task['crawl:ksh_kao120'].invoke
    Rake::Task['crawl:kormany_hu'].invoke(current_year)
    Rake::Task['crawl:mvh_gov_hu'].invoke(current_year)
    Rake::Task['crawl:nka'].invoke(current_year)

    kc = KozbeszerzesCrawler.new
    kc.valid_categories.each do |category|
      KozbeszerzesCrawler.new(year: current_year, category: category).crawl
    end

    InstanceManager.new.stop
  end

  desc 'Crawl All Historical'
  task all_historical: [:environment] do
    current_year = Time.zone.today.year

    Rake::Task['crawl:ksh_kao110'].invoke

    (MvhGovHuCrawler.new.valid_years.to_a - [current_year]).each do |year|
      MvhGovHuCrawler.new(year: year).crawl
    end

    (NkaCrawler.new.valid_years.to_a - [current_year]).each do |year|
      NkaCrawler.new(year: year).crawl
    end

    (KormanyHuCrawler.new.valid_years.to_a - [current_year]).each do |year|
      KormanyHuCrawler.new(year: year).crawl
    end

    kc = KozbeszerzesCrawler.new
    (kc.valid_years.to_a - [current_year]).each do |year|
      kc.valid_categories.each do |category|
        KozbeszerzesCrawler.new(year: year, category: category).crawl
      end
    end

    InstanceManager.new.stop
  end

  desc 'Crawl KSH'
  task ksh: [:environment] do
    KshKao110Crawler.new.crawl
    KshKao120Crawler.new.crawl
  end

  desc 'Crawl KSH KAO 110'
  task ksh_kao110: [:environment] do
    KshKao110Crawler.new.crawl
  end

  desc 'Crawl KSH KAO 120'
  task ksh_kao120: [:environment] do
    KshKao120Crawler.new.crawl
  end

  desc 'Crawl kormany.hu'
  task :kormany_hu, [:year] => [:environment] do |_t, args|
    if args[:year].present?
      KormanyHuCrawler.new(year: args[:year].to_i).crawl
    else
      KormanyHuCrawler.new.valid_years.each do |year|
        KormanyHuCrawler.new(year: year).crawl
      end
    end
  end

  desc 'Crawl kozbeszerzes.hu'
  task :kozbeszerzes, [:year, :category] => [:environment] do |_t, args|
    if args[:year].present?
      KozbeszerzesCrawler.new(year: args[:year].to_i, category: args[:category]).crawl
    else
      kc = KozbeszerzesCrawler.new
      kc.valid_years.each do |year|
        kc.valid_categories.each do |category|
          KozbeszerzesCrawler.new(year: year, category: category).crawl
        end
      end
    end
  end

  desc 'Crawl mvh.gov.hu'
  task :mvh_gov_hu, [:year] => [:environment] do |_t, args|
    if args[:year].present?
      MvhGovHuCrawler.new(year: args[:year].to_i).crawl
    else
      MvhGovHuCrawler.new.valid_years.each do |year|
        MvhGovHuCrawler.new(year: year).crawl
      end
    end
  end

  desc 'Crawl NKA'
  task :nka, [:year] => [:environment] do |_t, args|
    if args[:year].present?
      NkaCrawler.new(year: args[:year].to_i).crawl
    else
      NkaCrawler.new.valid_years.each do |year|
        NkaCrawler.new(year: year).crawl
      end
    end
  end
end
