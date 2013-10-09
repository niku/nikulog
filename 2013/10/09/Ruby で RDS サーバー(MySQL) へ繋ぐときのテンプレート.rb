# Ruby で RDS サーバー(MySQL) へ繋ぐときのテンプレート
require 'mysql2'

host = 'theinstancename.abcdef123456.ap-northeast-1.rds.amazonaws.com'
port = 3306
username = 'niku'
password = ''
database = 'niku-no-database'

client = Mysql2::Client.new(host: host, port: port, username: username, password: password, database: database)

# テーブル一覧取得
tables = client.query('show tables').flat_map(&:values)

# foo テーブルのカラム名一覧取得
foo_columns = client.query('show columns from foo').flat_map { |c| c['Field'] }
