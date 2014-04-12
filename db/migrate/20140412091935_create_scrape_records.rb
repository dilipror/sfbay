class CreateScrapeRecords < ActiveRecord::Migration
  def change
    create_table :scrape_records do |t|
      t.string :title
      t.string :mileage
      t.timestamps
    end
  end
end
