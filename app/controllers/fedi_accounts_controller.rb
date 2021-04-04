class FediAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fedi_account, only: %i[ show edit update destroy ]

  # GET /fedi_accounts
  def index
    @fedi_accounts = current_user.fedi_accounts.all.paginate(page: params[:page])
  end

  # GET /fedi_accounts/1
  def show
  end

  # GET /fedi_accounts/new
  def new
    @fedi_account = FediAccount.new
    @fedi_account.user_id = current_user.id
  end

  # GET /fedi_accounts/1/edit
  def edit
  end

  # POST /fedi_accounts
  def create
    ActiveRecord::Base.transaction do
      @fedi_account = FediAccount.new(fedi_account_params)
      @fedi_account.handle
      @fedi_account.user_id = current_user.id
      @fedi_account.authorize_and_save!(params[:password])
    end
    redirect_to @fedi_account, notice: "Fedi account was successfully created and authorized."
  rescue FediAccount::FediAccountError, ActiveRecord::RecordInvalid => error
    redirect_to new_fedi_account_url, notice: "Invalid credentials, could not save fedi account."
  end

  # PATCH/PUT /fedi_accounts/1
  def update
    @fedi_account.update!(fedi_account_params)
    redirect_to @fedi_account, notice: "Fedi account was successfully updated."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to edit_fedi_account_url, notice: "Fedi account couldn't be updated"
  end

  # DELETE /fedi_accounts/1 
  def destroy
    @fedi_account.destroy!
    redirect_to fedi_accounts_url, notice: "Fedi account was successfully destroyed."
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_fedi_account
    id = params[:id].nil? ? params[:fedi_account_id] : params[:id]
    @fedi_account = FediAccount.find_by(user_id: current_user.id, id: id)
  end

  # Only allow a list of trusted parameters through.
  private def fedi_account_params
    params.fetch(:fedi_account).permit(:handle)
  end

end
