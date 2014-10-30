class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :user_id, :start_date, :end_date, presence: true
  validates :status, inclusion: { in: ["PENDING", "APPROVED", "DENIED"] }
  validate :overlapping_approved_requests
  belongs_to(:cat)
  belongs_to(:user)
  
  has_one(
  :cat_owner,
  through: :cat,
  source: :owner
  )
  
  def overlapping_requests
    args = [
      self.start_date.to_s, 
      self.end_date.to_s, 
      self.start_date, 
      self.end_date, 
      self.cat_id
    ]
    requests = CatRentalRequest.find_by_sql([<<-SQL, *args])
      SELECT *
      FROM cat_rental_requests
      WHERE 
      (start_date BETWEEN ? AND ?) 
        AND 
        (end_date BETWEEN ? AND ?)
        AND 
        cat_id = ?
    SQL
    requests
    
  end
  
  def overlapping_approved_requests
    requests = overlapping_requests
    if !requests.empty?
      counter = 0
      requests.each { |request| counter += 1 if request.status == "APPROVED" } 
      if counter > 1
        errors[:cat_id] << "This cat is booked for the times you chose."
      end
    end
    return
  end
  
  def overlapping_pending_requests
    requests = overlapping_requests
    requests.each { |request| request.deny! }
  end
  
  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save!
      overlapping_pending_requests
    end
  end
  
  def deny!
    self.update!(status: "DENIED") if self.status == "PENDING"
  end
  
  def pending?
    self.status == "PENDING"
  end
end






