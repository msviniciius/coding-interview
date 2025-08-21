module Reports
  class UserTweetsRawReport
    REPORT_TYPE = :user_tweets
    REPORT_NAME = "User Tweets Raw Report"

    def self.call
      new.call
    end

    def call
      results = fetch_user_tweets
      return if results.empty?

      report_content = build_report_content(results)
      save_report(report_content)
    end

    private

    # Busca todos os usuários com seus tweets
    def fetch_user_tweets
      sql = <<~SQL
        SELECT 
          u.display_name AS user_name, 
          u.email AS user_email, 
          t.body AS tweet_body, 
          t.created_at AS tweet_created_at
        FROM users u
        LEFT JOIN tweets t ON t.user_id = u.id
        ORDER BY u.id, t.created_at;
      SQL

      ActiveRecord::Base.connection.exec_query(sql).to_a
    end

    # Monta o conteúdo do relatório
    def build_report_content(results)
      results.map do |row|
        tweet_info = row['tweet_body'].present? ? "Tweet: #{row['tweet_body']} (#{row['tweet_created_at']})" : "Sem tweets"
        "Usuário: #{row['user_name']} (#{row['user_email']}) - #{tweet_info}"
      end.join("\n")
    end

    # Salva no banco de dados
    def save_report(content)
      Report.create!(
        name: REPORT_NAME,
        report_type: REPORT_TYPE,
        content: content
      )
    end
  end
end
