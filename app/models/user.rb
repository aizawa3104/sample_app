class User < ApplicationRecord
    # before_save { self.email = email.downcase }
    before_save { email.downcase! }
    # downcaseは小文字にするメソッド
    validates :name, presence: true, length:{maximum:50}
    # メールアドレスの正規表現　この正規表現は一般的に使える正規表現なのか？
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    # 存在性確認、長さの制限、フォーマット、一意性の制限をかける、{ case_sensitive: false }は大文字と小文字を無視させるオプション
    validates :email, presence: true, length:{maximum:255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
end
