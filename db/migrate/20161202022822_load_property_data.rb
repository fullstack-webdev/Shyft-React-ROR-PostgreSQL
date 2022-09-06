class LoadPropertyData < ActiveRecord::Migration
  def up
    names = [ "car", "smart-serve", "food-handler-certificate"]

    for t in names
      Property.create(:name => t)
    end
  end

  def down
    Property.delete_all
  end
end
