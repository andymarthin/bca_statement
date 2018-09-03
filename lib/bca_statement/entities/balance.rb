module BcaStatement
  module Entities
    class Balance < Base
      extend ModelAttribute
      attribute :account_number, :string
      attribute :currency, :string
      attribute :balance, :float
      attribute :available_balance, :float
      attribute :float_amount, :float
      attribute :hold_amount, :float
      attribute :plafon, :float

      def initialize(attributes = {})
        set_attributes(attributes)
      end

    end
  end
end
