# config: utf-8

require 'fileutils'
require 'active_record'

module Todo
  module Db
    # DBの接続とテーブルの作成を行う
    def self.prepare

      # データベースのファイルのパスをとる
      database_path = File.join(ENV['HOME'], '.todo', 'todo.sqlite3') # => /.todo/todo.sqlite3

      puts database_path

      # データベースに接続する
      ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: database_path

      puts '接続完了'

      # テーブルがなかったらテーブルを作成する
      FileUtils.mkdir_p File.dirname(database_path)

      connection = ActiveRecord::Base.connection

      connection.table_exists?(:tasks)

      connection.create_table :tasks do |t|
        t.column :name, :string, null: false
        t.column :content, :text, null: false
        t.column :state, :integer, null: false, default: 0
        t.timestamps
      end
      connection.add_index :tasks, :state
      connection.add_index :tasks, :created_at
    end
    # あとでprivateで各メソッドを隠蔽する
  end
end
