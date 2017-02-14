# frozen_string_literal: true
require 'invalid_year'
require 'invalid_category'

module CrawlerCore
  extend ActiveSupport::Concern

  included do
    attr_reader :results
  end

  def initialize(year: nil, category: nil)
    @results = []
    @year = year
    @category = category
    @debug = ENV['DEBUG'].try(:downcase) == 'true'
  end

  def crawl
    log_crawler_start
    validate!
    create_data_source_or_log_no_changes(gather_changes)
  # TODO: specify error types, e.g. [Watir::Wait::TimeoutError, Watir::Exception::UnknownObjectException]
  rescue StandardError => e
    Rails.logger.error "#{e.class.name} happened:\n #{e.message}\n #{e.backtrace.join("\n")}" \
  end

  private

  def log_crawler_start
    Rails.logger.info "#{self.class.name} started to gather data " \
                      "from #{@year}#{' in debug mode' if @debug}."
  end

  def validate!
    validate_year! if valid_years.present?
    validate_categories! if valid_categories.present?
  end

  def validate_year!
    raise InvalidYear.new(self.class.name, @year, valid_years) unless valid_years.include? @year
  end

  def validate_categories!
    raise InvalidCategory.new(self.class.name, @category, valid_categories) unless valid_categories.include? @category
  end

  def valid_years; end

  def valid_categories; end

  def gather_changes
    []
  end

  def with_browser
    watir_browser = ENV.fetch('WATIR_BROWSER').to_sym
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 300
    Watir.default_timeout = 300
    @browser = if watir_browser == :phantomjs
                 Watir::Browser.new(watir_browser, args: ['--ignore-ssl-errors=true'], http_client: http_client)
               else
                 Watir::Browser.new(watir_browser, http_client: http_client, url: 'http://localhost:8910')
               end
    yield(@browser)
  ensure
    @browser.try(:close)
  end

  def create_data_source_or_log_no_changes(changeset)
    return unless data_table
    if data_table.data_has_changed(changeset)
      create_data_source(changeset)
    else
      Rails.logger.info "#{data_table.title}: no changes since last crawling."
    end
    data_table.touch(:last_fetched_at)
  end

  def data_table; end

  def create_data_source(changeset)
    data_table.data_sources.create!(
      changeset: changeset,
      changeset_headers: data_table.changeset_headers
    )
    Rails.logger.info "DataSource was created with #{changeset.size} items."
  end
end
