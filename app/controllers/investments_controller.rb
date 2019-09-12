class InvestmentsController < ApplicationController
  include DotHelper
  include ActionView::Helpers::TextHelper
  include SortableTable

  def index
    set_table_sort sorts: %w[amount account financial_year investment_type purchased_on units app current_nav], default: { purchased_on: :desc }

    @investments = Investment.all.reorder(table_sort)
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
