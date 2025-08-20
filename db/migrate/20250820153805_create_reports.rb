class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.text :content
      t.string :report_type

      t.timestamps
    end
  end
end
