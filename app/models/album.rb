class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures, :order => 'position', :dependent => true

  validates_presence_of :user_id  
  validates_length_of :name, :in => 1...50

  acts_as_list :scope => 'user_id'
  #acts_as_taggable
end
