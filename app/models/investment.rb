class Investment < ActiveRecord::Base
  include LiquidDroppable
  acts_as_mappable
  default_scope { order(purchased_on: :desc) }

  INVESTMENT_TYPES = ['Mutual Funds', 'PPF', 'Gold']

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
end
