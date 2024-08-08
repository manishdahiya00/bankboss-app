class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :video_url
      t.string :title
      t.string :subtitle
      t.text :description
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
