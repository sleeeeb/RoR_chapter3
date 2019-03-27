

  require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end


  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end


    test "should not allow the admin attribute to be edited via the web" do
      log_in_as(@other_user)                                                    # @other_userでログインする
      assert_not @other_user.admin?                                             # @toher_userが管理権限あれば(adminがtrueなら)falseを返す
      patch user_path(@other_user), params: {                                   # /users/@other_user へparamsハッシュの中身を送る
                                    user: { password:               'password',
                                            password_confirmation:  'password',
                                            admin: true } }
      assert_not @other_user.reload.admin?                                      # @other_userを再読み込みし、admin論理値が変更されてないか検証(falseやnilならtrue)
    end

end
