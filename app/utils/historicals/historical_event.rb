module Historicals
  class HistoricalEvent
    include Comparable

    attr_reader :date, :type, :source
    attr_accessor :current_quantity

    def initialize(date:, type:, source:)
      @date = date || Date.new(1999,1,1)
      @type = type
      @source = source
      @current_quantity = 0
    end

    def <=>(other)
      date <=> other.date
    end

    def dividend?
      type == :dividend
    end

    def dividend_calculations
      return {} if !dividend?
      divider = source.share.get_amount_divider
      amount = source.amount/divider
      gross_value = amount * @current_quantity
      net_value = gross_value * 0.75
      { divider: divider, amount: amount, gross_value: gross_value, net_value: net_value }
    end

    def quantity_delta
      case type
      when :holding
        source.amount + (source.amount_sold || 0)
      when :sale
        -source.amount
      when :dividend
        0
      else
        0
      end
    end

    def relevant?
      !irrelevant?
    end

    def irrelevant?
      dividend? && current_quantity == 0
    end
  end
end