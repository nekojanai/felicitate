class FediAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fedi_account, only: %i[ show edit update destroy ]

  # GET /fedi_accounts or /fedi_accounts.json
  def index
    @fedi_accounts = current_user.fedi_accounts.all.paginate(page: params[:page])
  end

  # GET /fedi_accounts/1 or /fedi_accounts/1.json
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

  # POST /fedi_accounts or /fedi_accounts.json
  def create
    pp password = params[:password]
    @fedi_account = FediAccount.new(fedi_account_params)
    @fedi_account.user_id = current_user.id
   
    respond_to do |format|
      if @fedi_account.save
        format.html { redirect_to @fedi_account, notice: "Fedi account was successfully created." }
        format.json { render :show, status: :created, location: @fedi_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fedi_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fedi_accounts/1 or /fedi_accounts/1.json
  def update
    respond_to do |format|
      if @fedi_account.update(fedi_account_params)
        format.html { redirect_to @fedi_account, notice: "Fedi account was successfully updated." }
        format.json { render :show, status: :ok, location: @fedi_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fedi_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fedi_accounts/1 or /fedi_accounts/1.json
  def destroy
    @fedi_account.destroy
    respond_to do |format|
      format.html { redirect_to fedi_accounts_url, notice: "Fedi account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_fedi_account
    id = params[:id].nil? ? params[:fedi_account_id] : params[:id]
    @fedi_account = FediAccount.find_by(user_id: current_user.id, id: id)
  end

  # Only allow a list of trusted parameters through.
  private def fedi_account_params
    params.fetch(:fedi_account, {}).permit(:handle)
  end

end
