class InvestmentsController < ApplicationController
  def index
    @investments = Investment.all
  end

  def show
  end

  def new
    @investment = Investment.new
  end
end
