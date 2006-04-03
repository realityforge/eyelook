class PictureData < ActiveRecord::Base
  belongs_to :picture 
  validates_presence_of :picture_id, :name, :content_type, :data 
end
