class Tag < ActiveRecord::Base
  validates_length_of :name, :within => 1..40
  validates_uniqueness_of :name
end
