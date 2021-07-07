namespace :create_unit_data do
  desc "素材データの作成"
  def logger
    Rails.logger
  end

  def create_unit(number, type, datas, isBonus, date)
    datas.each do |data|
      @unit = Unit.find_or_create_by(
        number: number,
        type_number: type,
        unit: data.to_i,
        bonus: isBonus,
        year: date.year,
        month: date.month,
        day: date.day
      )
      next if @unit.rokuyou
      logger.info "number:#{number}, type:#{type}, date:#{date}"
      # 旧暦APIをぶっ叩く
      api_date = "#{date.year}-#{date.month}-#{date.day}"
      uri = URI.parse("http://dateinfoapi.appspot.com/v1?date=#{api_date}")
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.open_timeout = 5
        http.read_timeout = 10
        http.get(uri.request_uri)
      end

      begin
        case response
        when Net::HTTPSuccess
          @result = JSON.parse(response.body)
          @unit.old_date = @result['old_date']
          @unit.rokuyou = @result['rokuyo']
          @unit.save
        else
          logger.error "ERROR API"
        end
      rescue => e
        logger.error "ERROR API:#{e}"
      end
    end
  end

  task exec: :environment do
    # scrapingデータの取得
    scrapings = Loto.all.order(:date)
    scrapings.each do |data|

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
