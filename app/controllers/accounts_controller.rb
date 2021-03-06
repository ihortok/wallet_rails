class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[show edit update destroy]
  after_action :super_owner, only: :create

  def index
    @accounts = current_user.accounts
  end

  def show; end

  def new
    @account = Account.new
  end

  def edit; end

  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        current_user.accounts << @account

        format.html { redirect_to @account, notice: 'Account was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
    end
  end

  private

  def super_owner
    current_user.account_ownerships.where(account: @account).update(super_owner: true)
  end

  def set_account
    @account = Account.by_user(current_user.id).find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :balance, :note, :currency_id)
  end
end
