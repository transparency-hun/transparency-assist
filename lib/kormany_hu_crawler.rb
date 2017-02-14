# frozen_string_literal: true
require 'crawler_core'

class KormanyHuCrawler
  include CrawlerCore

  def valid_years
    2014..Time.zone.today.year
  end

  private

  def data_table
    @data_table ||= init_data_table
  end

  def init_data_table
    data_table = DataTable.find_or_create_by!(
      category: Category.find_or_create_by!(name: 'Kormány'),
      title: "A Kormány.hu-n közzétett szerződések listája - #{@year}",
      source: 'kormany.hu',
      official: true,
      confirmed: true,
      year: @year
    )
    if data_table.changeset_headers.blank?
      data_table.update_changeset_headers!(changeset_header_keys)
    end
    data_table
  end

  def changeset_header_keys
    %w(published_on title agency link)
  end

  def gather_changes
    current_page = 1

    with_browser do |browser|
      loop do
        Rails.logger.debug "Page##{current_page}"
        page = page_content(browser, current_page)
        break unless page

        process_page(page)
        break if last_page?(browser)

        current_page += 1
      end
    end

    @results.reverse
  end

  def process_page(page)
    page.at_css('#DocumentResult').css('.article').each do |article|
      result = parse_result(article)
      @results << result
    end
  end

  def parse_result(result)
    title = result.at_css('h2').text
    published = result.at_css('h3').text
    agency, date = published.split(/\s*,\s*/)
    link = result.at_css('h2 a')['href']

    { title: title, agency: agency, published_on: date, link: link }
  end

  def page_content(browser, page)
    url = url_to_crawl(page)

    browser.goto(url)
    browser.div(id: 'DocumentResult').wait_until_present

    Nokogiri::HTML(browser.html)
  rescue Watir::Wait::TimeoutError => _e
    nil
  end

  def url_to_crawl(page)
    # Szerzodesek only
    q = { year: @year, page: page, type: 204 }.to_query

    'http://www.kormany.hu/hu/dok?' + q
  end

  def last_page?(browser)
    browser.a(class: 'next disabled').exists?
  end
end
