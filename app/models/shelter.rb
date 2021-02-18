class Shelter < ApplicationRecord
  has_many :pets

  def self.all_desc
    find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  def self.with_pending_applications
    where(status: "Pending")
  end

  def self.admin_show_query(id)
    find_by_sql("SELECT name, address, city, state, zip FROM shelters WHERE id = #{id}")
  end
end
