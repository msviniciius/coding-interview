class User < ApplicationRecord
  belongs_to :company, optional: true
  has_many :tweets, dependent: :destroy

  after_create_commit :send_welcome_email

  scope :by_company, ->(company_id) { 
    where(company_id: company_id) if company_id.present? 
  }

  # Buscar parciealmente e case-insensitive pelo username
  scope :by_username, -> (username) {
    return all if username.blank?

    where('username LIKE ?', "%#{username.downcase}%")
  }

  private

  def send_welcome_email
    SendWelcomeEmailJob.perform_later(self.id)
  end
end