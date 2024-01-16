class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  # callbacks
  before_validation :gen_api_key, on: :create
  before_validation :encrypt_password, on: :create
  # attributes
  field :email, type: String
  field :password_digest, type: String
  # create a virtual attribute (not persisted to the db) for the password
  attr_accessor :password, :password_confirmation
  field :api_key, type: String
  # validations
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true, presence: true
  validates :password_digest, presence: true
  validates :api_key, uniqueness: true, allow_blank: true

  def self.authenticate(email, password)
    user = User.find_by!(email: email)  # will raise Mongoid::Errors::DocumentNotFound if not found

    if user && BCrypt::Password.new(user.password_digest) == password
      return user
    else
      raise Mongoid::Errors::DocumentNotFound.new(User, {password: password})
    end
  end

  private

  def gen_api_key
    loop do
      self.api_key = "sweaty." + SecureRandom.hex(3)
      break unless User.where(api_key: api_key).exists?
    end
  end

  def encrypt_password
    if password == password_confirmation && password.present?
      self.password_digest = BCrypt::Password.create(password)
    end
  end
end
