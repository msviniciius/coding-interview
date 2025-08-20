module Reports
  class CompanyUsersReport
    REPORTS_DIR = Rails.root.join("tmp", "reports")

    def self.call
      new.call
    end

    def call
      companies = Company.joins(:users)
                         .select("companies.id, companies.name, COUNT(users.id) AS users_count")
                         .group("companies.id, companies.name")

      report_lines = companies.map { |c| "#{c.name} - Usuários: #{c.users_count}" }

      save_report("Company Users Report", "company_users", report_lines.join("\n"))
    end

    private

    def save_report(name, type, content)
      Report.create!(name: name, report_type: type, content: content)
    end
  end
end