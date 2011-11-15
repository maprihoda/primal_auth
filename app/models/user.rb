class User < ActiveRecord::Base
  attr_accessor :password

  attr_accessible :name, :email, :password, :password_confirmation

  validates :name, :presence => true, :length => { :maximum => 70 }

  # user will login with email and password
  validates :email, :presence   => true, :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, :uniqueness => { :case_sensitive => false }

  # user will be able to edit her profile without providing the password
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :allow_blank => true
  validates_length_of :password, :within => 6..40, :allow_blank => true

  before_save :prepare_password
  before_create { generate_token(:remember_token) }

  def self.authenticate(email, pass)
    user = find_by_email(email)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def reset_remember_token!
    generate_token(:remember_token)
    save(:validate => false)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end

