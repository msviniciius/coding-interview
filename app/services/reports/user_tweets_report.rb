module Reports
  class UserTweetsReport
    REPORTS_DIR = Rails.root.join("tmp", "reports")

    def self.call
      new.call
    end

    def call
      report_lines = []

      User.includes(:tweets).find_each do |user|
        report_lines << "Usuário: #{user.display_name} (#{user.email})"
        user.tweets.each do |tweet|
          report_lines << " - Tweet: #{tweet.body} (#{tweet.created_at})"
        end
        report_lines << "\n"
      end

      save_report("User Tweets Report", "user_tweets", report_lines.join("\n"))
    end

    private

    def save_report(name, type, content)
      Report.create!(name: name, report_type: type, content: content)
    end
  end
end
