class Cat < ActiveRecord::Base
  # validates :birth_date, timeliness: { on_or_before: Date.current }
  COLORS = ['black', 'white', 'brown', 'calico', 'orange']
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: ['M', 'F']}
  validates :name, :presence => true
  has_many(:cat_rental_requests,
  :dependent => :destroy)
  belongs_to(
    :owner,
    class_name: "User",
    primary_key: :id,
    foreign_key: :user_id
  )
  
  def age
    Date.current.year - birth_date.year
  end
end
