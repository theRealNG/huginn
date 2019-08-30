class DashboardController < ApplicationController
  def index
    @summary = Investment.summary
  end
end
