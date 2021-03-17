require "application_system_test_case"

class FediAccountsTest < ApplicationSystemTestCase
  setup do
    @fedi_account = fedi_accounts(:one)
  end

  test "visiting the index" do
    visit fedi_accounts_url
    assert_selector "h1", text: "Fedi Accounts"
  end

  test "creating a Fedi account" do
    visit fedi_accounts_url
    click_on "New Fedi Account"

    click_on "Create Fedi account"

    assert_text "Fedi account was successfully created"
    click_on "Back"
  end

  test "updating a Fedi account" do
    visit fedi_accounts_url
    click_on "Edit", match: :first

    click_on "Update Fedi account"

    assert_text "Fedi account was successfully updated"
    click_on "Back"
  end

  test "destroying a Fedi account" do
    visit fedi_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fedi account was successfully destroyed"
  end
end
