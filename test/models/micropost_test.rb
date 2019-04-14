require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # マイクロポストが正常かどうかのテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # ユーザーIDの存在性に対するテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # コンテンツの空データに対するテスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # コンテンツの文字数のテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # マイクロポストの順序付けをテストする
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end