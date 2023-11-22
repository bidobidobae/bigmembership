class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :reports
  has_secure_password
  has_one_attached :qrcode, dependent: :destroy

  generates_token_for :email_verification, expires_in: 2.days { email }
  generates_token_for :password_reset, expires_in: 20.minutes { password_salt.last(10) }

  has_many :sessions, dependent: :destroy
  has_many :recovery_codes, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 6 }
  validates :password, not_pwned: { message: "might easily be guessed" }
  validates :phone, presence: true, numericality: true, length: {minimum: 10, maximum: 15}, allow_blank: true

  normalizes :email, with: -> { _1.strip.downcase }

  before_commit :generate_qrcode, on: :create

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  before_validation on: :create do
    self.otp_secret = ROTP::Base32.random
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  before_save :update_active_date_and_status

  after_update_commit do
    update_broadcast
  end
  
  def update_broadcast
    broadcast_replace_to "user_point", partial: 'registrations/point', locals: { user: self }, target: "user_#{ self.id }_point"
  end

  def update_active_date_and_status
    if active_date_changed?
      self.expired_date = active_date + 1.year
      self.status = true
    end
  end

  def status_label
    if status
      "Active"
    else
      "Not Active"
    end
  end

  enum role: [:member, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active_date", "birth_date", "created_at", "email", "expired_date", "first_name", "id", "id_value", "last_name", "otp_required_for_sign_in", "otp_secret", "password_digest", "phone", "point", "provider", "role", "status", "uid", "updated_at", "verified"]
  end

    def self.ransackable_associations(auth_object = nil)
      ["qrcode_attachment", "qrcode_blob", "recovery_codes", "reports", "sessions"]
    end

  private

  def generate_qrcode
    host = Rails.application.config.action_controller.default_url_options[:host]
    qrcode = RQRCode::QRCode.new(profile_url(self, host:))
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 200
    )
    self.qrcode.attach(
      io:StringIO.new(png.to_s),
      filename: "qrcode.png",
      content_type: "image/png"
    )
  end
end
