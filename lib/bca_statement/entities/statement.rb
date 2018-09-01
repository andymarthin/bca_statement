module BcaStatement
  module Entities
    class Statement < Base
      extend ModelAttribute

      attribute :date, :string
      attribute :brance_code, :string
      attribute :type, :string
      attribute :amount, :float
      attribute :name, :string
      attribute :trailer, :string

      def initialize(attributes = {})
        set_attributes(attributes)
      end

    end
  end
end
