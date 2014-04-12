require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"
require 'nokogiri'
require 'debugger'

Capybara.run_server = false
Capybara.current_driver = :webkit
#Capybara.current_driver = :selenium
Capybara.default_wait_time = 20

module ScrapeResult
  class Scrape
    include Capybara::DSL
    attr_accessor :ad_links, :car_details

    def data_scraping
      navigate_url
      gather_the_ad_links
      navigate_ad_link
      car_mileage
      return_car_details
    end
    
    private

    def navigate_url
      visit 'http://sfbay.craigslist.org/cto/'
    end

    def gather_the_ad_links
      self.ad_links = all(".pl").map{|ad_link| ad_link.first('a')[:href]}
    end

    def navigate_ad_link
      self.ad_links.each_with_index do |ad_link|
        visit ("http://sfbay.craigslist.org" + ad_link)
        car_mileage
      end
    end

    def car_mileage
      self.car_details ||= []
      data = within(".attrgroup"){all("b")}
      details = {
        title: data[0].text,
        mileage: data[1].text
      }
      self.car_details << details
    end

    def return_car_details
      self.car_details
    end
  end

end