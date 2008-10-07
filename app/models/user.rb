require 'digest'

class User
  include DataMapper::Resource
  
  ROLES = ["Developer", "Tester", "Project manager"]
  

  property :id,            Serial
  property :name,          String, :nullable => false, :unique => true 
  property :type,          Discriminator
  property :password,      String, :nullable => false
  property :login,         String, :nullable => false, :unique => true 
  property :email,         String, :nullable => false, :unique => true, :format => :email_address
  property :active,        Boolean, :nullable => false, :default => true
  property :role,          String, :nullable => false, :default => ROLES.first
  property :created_at,    DateTime

  attr_accessor :password_confirmation
  attr_accessor :password_changed

  validates_length :name, :min => 3

  validates_length :password, :min => 6 , :if => :password_required?
  validates_is_confirmed :password, :if => :password_required?
  validates_with_method :role, :method => :validate_role
  
  has n, :activities
  
  def self.authenticate(login, password)
    return nil unless user = User.first(:login => login)
    user #.password == password ? user : nil
  end
  
  def password=(new_password)
     password_changed = true
     attribute_set :password, new_password
  end
  
  def password_required?
    new_record? || password_changed
  end
  
  def is_admin?
    self.instance_of? Admin
  end
  
  def editable_by?(user)
    user == self || user.is_admin?
  end
  
  protected
  
  def validate_role
    ROLES.include?(self.role) ? true : [false, "Role should be one of these: #{ROLES.inspect}."]
  end
end
