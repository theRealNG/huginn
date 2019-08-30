class Investment < ActiveRecord::Base
  include LiquidDroppable
  acts_as_mappable
  default_scope { order(purchased_on: :desc) }

  INVESTMENT_TYPES = ['Mutual Funds', 'PPF', 'Gold']
  APPS = ['FundsIndia', 'ICICI', 'GooglePay', 'PayTM', 'PayTM Money']

  before_validation :set_financial_year

  validates :app, inclusion: { in: APPS }
  validates :financial_year, presence: true

  case ActiveRecord::Base.connection.adapter_name
  when /\Amysql/i
    # Protect the Event table from InnoDB's AUTO_INCREMENT Counter
    # Initialization by always keeping the latest event.
    scope :to_expire, -> { expired.where.not(id: maximum(:id)) }
  else
    scope :to_expire, -> { expired }
  end

  def current_value
    units * current_nav
  end

  def percentage_change
    ((current_value - amount)/amount * 100)
  end

  private
  def set_financial_year
    year = purchased_on.year
    month = purchased_on.month

    financial_year= if month > 3
      "#{year}-#{year+1}"
    else
      "#{year-1}-#{year}"
    end
  end
end
