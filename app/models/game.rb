class Game < ApplicationRecord
  enum :condition, {
    mint: 1,
    excellent: 2,
    good: 3,
    as_is: 4
  }

  # price_cents stores the price in integer cents; render it as currency.
  # e.g. 3499 => "$34.99"
  def formatted_price
    ActiveSupport::NumberHelper.number_to_currency((price_cents || 0) / 100.0)
  end

  # Human-friendly condition label, e.g. "as_is" => "As is".
  def condition_label
    condition&.humanize
  end
end
