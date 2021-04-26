class Event < ApplicationRecord
  # model association
  belongs_to :user

  enum status: {draft: 1, published: 2}

  # validation
  validates_presence_of :name
	validate :dates_duration

	before_create :set_duration
	before_create :published?

	default_scope -> { where(deleted_at: nil) }
	
 def dates_duration
	unless [start_at, end_at, duration].reject(&:blank?).size >= 2
    errors[:base] << ('More data is needed to establish a duration. At least two values ​​of start_at, end_at or duration.')
	end
 end

 def published?
	#debugger if self.location = 'Palms Resort' and self.status = 'published' and self.description = 'Party'
	self.status = 'draft' unless self.attributes.except('id', 'deleted_at').values.all?
 end

 def set_duration
	if self.start_at
		self.end_at.present? ? (self.duration =  self.start_at - self.end_at) : (self.end_at = self.start_at + self.duration.to_i.days)
	else
		self.start_at = self.end_at - self.duration.to_i.days
	end
 end
end
