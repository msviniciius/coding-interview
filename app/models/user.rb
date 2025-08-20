class User < ApplicationRecord
  belongs_to :company

  scope :by_company, ->(company_id) { 
    where(company_id: company_id) if company_id.present? 
  }

  # Buscar parciealmente e case-insensitive pelo username
  scope :by_username, -> (username) {
    return all if username.blank?

    where('username LIKE ?', "%#{username.downcase}%")
  }
end