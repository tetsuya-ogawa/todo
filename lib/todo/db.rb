# config: utf-8

require 'fileutils'
require 'active_record'

module Todo
  module Db
    # DBの接続とテーブルの作成を行う
    def self.prepare
      # データベースのファイルのパスをとる
      database_path = File.join(ENV['HOME'], '.todo', 'todo.sqlite3') # => ~/.todo/todo.sqlite3
      connect_databese database_path
      create_table_if_not_exists database_path
    end

    def self.connect_databese(path)
      # データベースに接続する
      ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: path
    end

    def self.create_table_if_not_exists(path)
      # テーブルがなかったらテーブルを作成する
      FileUtils.mkdir_p File.dirname(path)
      connection = ActiveRecord::Base.connection

      return if connection.table_exists?(:tasks)

      connection.create_table :tasks do |t|
        t.column :name, :string, null: false
        t.column :content, :text, null: false
        t.column :state, :integer, null: false, default: 0
        t.timestamps
      end
      connection.add_index :tasks, :state
      connection.add_index :tasks, :created_at
    end

    private_class_method :connect_databese, :create_table_if_not_exists
  end
end
