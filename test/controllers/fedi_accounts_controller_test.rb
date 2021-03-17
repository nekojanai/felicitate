require "test_helper"

class FediAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fedi_account = fedi_accounts(:one)
  end

  test "should get index" do
    get fedi_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_fedi_account_url
    assert_response :success
  end

  test "should create fedi_account" do
    assert_difference('FediAccount.count') do
      post fedi_accounts_url, params: { fedi_account: {  } }
    end

    assert_redirected_to fedi_account_url(FediAccount.last)
  end

  test "should show fedi_account" do
    get fedi_account_url(@fedi_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_fedi_account_url(@fedi_account)
    assert_response :success
  end

  test "should update fedi_account" do
    patch fedi_account_url(@fedi_account), params: { fedi_account: {  } }
    assert_redirected_to fedi_account_url(@fedi_account)
  end

  test "should destroy fedi_account" do
    assert_difference('FediAccount.count', -1) do
      delete fedi_account_url(@fedi_account)
    end

    assert_redirected_to fedi_accounts_url
  end
end
