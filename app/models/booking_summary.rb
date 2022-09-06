# NOTE - Summary of important booking detail information

class BookingSummary < ActiveRecord::Base
    belongs_to :booking

    def displayed_tax_rate
      self.tax_rate * 100
    end

    def displayed_service_fee
      self.service_fee_rate * 100
    end
end
