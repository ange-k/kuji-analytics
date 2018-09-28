class Loto < ApplicationRecord
  def self.cnv_type_number(str)
    case str
      when 'miniloto' then
        1
      when 'loto6' then
        2
      when 'loto7' then
        3
      else
        0
    end
  end
end
