class InvestmentsController < ApplicationController
  def index
    @investments = Investment.all
  end

  def show
  end

  def new
    @investment = Investment.new
  end

  def create
     @investment = Investment.create(
      amount: investment_params['amount'],
      investment_type: investment_params['investment_type'],
      tax_saving: ( investment_params['tax_saving'] == "1" ? true : false ),
      purchased_on: investment_params['purchased_on'],
      account: investment_params['account'],
      app: investment_params['app'],
      units: investment_params['units'],
    )

    if @investment.id.present?
      redirect_to investments_path
    else
      render 'new'
    end
  end

  private
  def investment_params
    params.require('investment').permit(['amount', 'investment_type', 'tax_saving', 'purchased_on', 'account', 'app', 'units'])
  end
end
