class User < ActiveRecord::Base
  validates_length_of :name, :within => 1..20
  validates_uniqueness_of :name

  has_many :albums, :order => 'position', :dependent => true

  def self.authenticate(name, password)
    user = find_by_name(name)
    return nil unless user
    find(:first,  :conditions => ['name = ? AND password = ?', name, User.encode_password(user.salt,password)])
  end

  def password_matches?(password)
    User.encode_password(self.salt,password) == read_attribute('password')
  end

  def password; ''; end

  def password=(password)
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{name}--")
    write_attribute('password', User.encode_password(self.salt,password))
  end

private
  def self.encode_password(salt,password)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
end
