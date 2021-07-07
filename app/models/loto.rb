# number        :開催回
# type_number   :くじ種別
# result        :くじ結果
# bonus_number  :ボーナスナンバー
# date          :抽選日
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
