class User < ApplicationRecord
  attr_accessor :remember_token

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

    # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    # クラスメソッドとして定義している
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

end
