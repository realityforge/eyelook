class Picture < ActiveRecord::Base
  belongs_to :album
  has_one :picture_data, :dependent => true

  validates_presence_of :album_id, :content_type
  validates_length_of :caption, :in => 1...50
  validates_uniqueness_of :caption, :scope => 'album_id'

  acts_as_taggable
  acts_as_list :scope => :album_id

  def text_tags; tag_names.join(' '); end
  alias :text_tags= :tag_names=

  def filename
    "#{position}.#{content_type.gsub(/.+\//,'')}"
  end
  
  def data=(data_field)
    data = data_field.read
    image = Magick::Image.from_blob(data).first
    self.width = image.columns
    self.height = image.rows
    self.content_type = data_field.content_type.chomp
    self.picture_data = PictureData.new(:picture_id => id, :data => data)
  end

  def to_image
    Magick::Image.from_blob(self.picture_data.data).first
  end
end
