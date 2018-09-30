namespace :create_unit_data do
  desc "素材データの作成"
  def logger
    Rails.logger
  end

  def create_unit(number, type, datas, isBonus, date)
    datas.each do |data|
      Unit.create(
          number: number,
          type_number: type,
          unit: data.to_i,
          bonus: isBonus,
          year: date.year,
          month: date.month,
          day: date.day
      )
    end
  end

  task exec: :environment do
    # TODO: 解析データと新旧突き合わせて、更新する差分だけ取得するようにする
    # scrapingデータの取得
    scrapings = Loto.all.order(:date)

    scrapings.each do |data|
      logger.debug "#{data.number}: #{data.type_number}"
      create_unit(
          data.number,
          data.type_number,
          data.result.split(','),
          false,
          data.date)
      create_unit(
          data.number,
          data.type_number,
          data.bonus_number.split(','),
          true,
          data.date)
    end
  end
end
