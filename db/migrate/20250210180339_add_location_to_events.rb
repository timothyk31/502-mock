# frozen_string_literal: true

class AddLocationToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :location, :string
  end
end
