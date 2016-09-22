module TDAmeritradeAPI
  class Entity

    attr_reader :file_name

    def initialize(attributes = {})
      attributes.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def self.import(file, file_name)
      entities = []

      CSV.foreach(file) do |row|
        attributes = Hash[self::HEADERS.zip(row)]
        attributes[:file_name] = file_name
        entities << new(attributes)
      end

      return entities
    end

    def date_from_file_name
      Date.strptime(file_name.gsub(/\D/, ''), '%y%m%d')
    end

    def parsed_date(date)
      date = date.gsub(/\D/, '')

      if date.length == 6
        Date.strptime(date, '%m%d%y')
      elsif date.length == 8
        Date.strptime(date, '%m%d%Y')
      else
        nil
      end
    end

  end

  class CostBasisReconciliation < Entity
    HEADERS = %w(custodial_id business_date account_number account_type security_type symbol current_quantity cost_basis adjusted_cost_Basis unrealized_gain_loss cost_basis_fully_known certified_flag original_purchase_date original_purchase_price wash_sale_indicator disallowed_amount)

    attr_reader :custodial_id, :business_date, :account_number, :account_type, :security_type, :symbol,
                :current_quantity, :cost_basis, :adjusted_cost_Basis, :unrealized_gain_loss, :cost_basis_fully_known,
                :certified_flag, :original_purchase_date, :original_purchase_price, :wash_sale_indicator,
                :disallowed_amount
  end

  class DemographicFile < Entity
  end

  class InitialPosition < Entity
  end

  class Position < Entity
    HEADERS = %w(account_number account_type security_type symbol quantity amount)

    attr_reader :account_number, :account_type, :security_type, :symbol, :quantity, :amount
  end

  class Price < Entity
    HEADERS = %w(symbol security_type date price factor)

    attr_reader :symbol, :security_type, :date, :price, :factor

    def initialize(attributes = {})
      super
      @date = date_from_file_name
    end
  end

  class Security < Entity
    HEADERS = %w(symbol security_type description expiration_date call_date call_price issue_date first_coupon interest_rate share_per_contract annual_income_amount comment)

    attr_reader :symbol, :security_type, :description, :expiration_date, :call_date, :call_price, :issue_date,
                :first_coupon, :interest_rate, :share_per_contract, :annual_income_amount, :comment

    def initialize(attributes = {})
      super
      @expiration_date = parsed_date(attributes[:expiration_date].to_s)
      @call_date = parsed_date(attributes[:call_date].to_s)
      @issue_date = parsed_date(attributes[:issue_date].to_s)
    end
  end

  class Transaction< Entity
    HEADERS = %w(broker_account file_date account_number transaction_code activity cancel_status_flag symbol security_type trade_date quantity net_amount principal_amount broker_fee other_fees settle_date from_to_account account_type accrued_interest closing_account_method comments)

    attr_reader :broker_account, :file_date, :account_number, :transaction_code, :activity, :cancel_status_flag,
                :symbol, :security_type, :trade_date, :quantity, :net_amount, :principal_amount, :broker_fee,
                :other_fees, :settle_date, :from_to_account, :account_type, :accrued_interest, :closing_account_method,
                :comments
  end
end