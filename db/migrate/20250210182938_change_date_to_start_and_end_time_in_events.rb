class ChangeDateToStartAndEndTimeInEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :date, :date
    add_column :events, :start_time, :datetime, null: false
    add_column :events, :end_time, :datetime
    add_column :events, :attendance_code, :string
  end
end
