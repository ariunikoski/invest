module Historicals
  class HistoricalLedger
    attr_reader :events

    def initialize(events)
      @events = events.sort
      compute_running_quantities
    end

    def compute_running_quantities
      quantity = 0

      events.each do |event|
        quantity += event.quantity_delta
        event.current_quantity = quantity
      end
    end

    def dividends_between(start_date, end_date)
      range = start_date..end_date

      events.select { |e| e.type == :dividend && range.cover?(e.date) }
    end
  end
end