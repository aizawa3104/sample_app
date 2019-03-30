class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      # log_inメソッドはsessions_helper.rbで定義している
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # [remember me] チェックボックスの送信結果を処理する 三項演算子
      # params[:session][:remember_me] == '1' が真ならremember(user) 、偽ならforget(user)
      # remember user
      # ↑永続セッション　セッションに関するモジュールのリメンバー
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
