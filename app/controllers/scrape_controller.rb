require 'scrape'

class ScrapeController < ApplicationController

  def create
    begin
      scrape_result_obj = ScrapeResult::Scrape.new
      car_details = scrape_result_obj.data_scraping
      car_details.each do |car_detail|
        record = ScrapeRecord.find_or_initialize_by(title: car_detail[:title])
        record.update(title: car_detail[:title], mileage: car_detail[:mileage].to_i)
      end
      flash[:success] = 'Car mileage is stored' 
    rescue
      flash[:error] = 'Error: Car mileage is not stored'
    ensure
      redirect_to scrape_index_path
    end
  end

  def index
    @mileages = ScrapeRecord.all
  end

  def search
    if params["search"].blank?
      redirect_to scrape_index_path 
    else
      @mileages = ScrapeRecord.where("mileage = ?", params["search"])
      @search = params["search"]
      render 'index'
    end
    
  end

end
