class Picture < ActiveRecord::Base
  belongs_to :album
  has_one :picture_data, :dependent => true

  validates_presence_of :album_id
  validates_length_of :name, :in => 1...50
  validates_uniqueness_of :name, :scope => 'group_id'

  acts_as_taggable
  acts_as_list :scope => 'album_id'

  def filename
    "#{position}.#{picture_data.content_type.gsub(/.+\//,'')}"
  end
  
  def data=(data_field)
    self.picture_data =
        PictureData.new(:picture_id => id, 
                        :name => Picture.base_part_of(data_field.original_filename), 
                        :content_type => data_field.content_type.chomp, 
                        :data => data_field.read)
  end
  
  private

  def self.base_part_of(file_name)
    file_name.gsub(/^.*(\\|\/)/, '').gsub(/[^\w._-]/,'')
  end
end
