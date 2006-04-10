class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures, :order => 'position', :dependent => true

  validates_presence_of :user_id  
  validates_length_of :permalink, :in => 1...50
  validates_length_of :caption, :in => 1...50

  acts_as_list :scope => 'user_id'
  acts_as_taggable

  def text_tags; tag_names.join(' '); end
  alias :text_tags= :tag_names=

  def expire_pages
    FileUtils.rm_rf(Dir["#{RAILS_ROOT}/public/#{user.name}/#{permalink}"])
  end
end
