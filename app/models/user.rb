class User < ApplicationRecord
  belongs_to :company, optional: true
  has_many :tweets, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :display_name, presence: true
  
  after_create_commit :send_welcome_email

  scope :by_company, ->(company_id) { 
    company_id.present? ? where(company_id: company_id) : all
  }

  # Buscar parciealmente e case-insensitive pelo username ou display_name
  scope :by_username_or_display_name, ->(term) {
    return all if term.blank?

    where('LOWER(username) LIKE :term OR LOWER(display_name) LIKE :term', term: "%#{term.downcase}%")
  }

  private

  def send_welcome_email
    SendWelcomeEmailJob.perform_later(self.id)
  end
end