class Investment < ActiveRecord::Base
  include LiquidDroppable
  acts_as_mappable

  default_scope { order(purchased_on: :desc) }
  scope :tax_saving_mutual_funds, -> { where(tax_saving: true, investment_type: 'Mutual Funds') }
  scope :non_tax_saving_mutual_funds, -> { where(tax_saving: false, investment_type: 'Mutual Funds') }
  scope :gold_investments, -> { where(investment_type: 'Gold') }
  scope :ppf_investments, -> { where(investment_type: 'PPF') }

  INVESTMENT_TYPES = ['Mutual Funds', 'PPF', 'Gold']
  APPS = ['FundsIndia', 'ICICI', 'GooglePay', 'PayTM', 'PayTM Money']

  before_validation :set_financial_year

  validates :app, inclusion: { in: APPS }
  validates :financial_year, presence: true

  def current_value
    case investment_type
    when 'Mutual Funds'
      units * current_nav
    when 'Gold'
      amount
    when 'PPF'
      amount
    end
  end

  def percentage_change
    ((current_value - amount)/amount * 100)
  end

  def self.summary
    results = {}
    financial_years = Investment.select(:financial_year).pluck(:financial_year)
    keys = [:tax_saving_mutual_funds, :non_tax_saving_mutual_funds, :gold_investments, :ppf_investments]
    financial_years.each do |year|

      results[year] = {}

      keys.each do |key|
        invested_amount = Investment.where(financial_year: year).send(key).sum(:amount).to_f
        current_value = Investment.where(financial_year: year).send(key).map(&:current_value).sum.to_f
        percentage_change = ((current_value - invested_amount)/invested_amount) * 100

        results[year][key] = {
          invested_amount: invested_amount,
          current_value: current_value,
          percentage_change: percentage_change
        }
      end
    end
    results
  end

  private
  def set_financial_year
    year = purchased_on.year
    month = purchased_on.month

    self.financial_year = if month > 3
      "#{year}-#{year+1}"
    else
      "#{year-1}-#{year}"
    end
  end
end
