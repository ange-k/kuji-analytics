# docker-compose run spring rake scraping:exec
namespace :scraping do
  desc "mizuhoをスクレイピング"

  def logger
    Rails.logger
  end

  task exec: :environment do
    require 'capybara/poltergeist'

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
    end
    Capybara.default_max_wait_time = 20
    session = Capybara::Session.new(:poltergeist)
    session.visit "https://www.mizuhobank.co.jp/retail/takarakuji/loto/backnumber/index.html"

    logger.info "status=#{session.status_code}"

    anker_list = []

    table = session.all('.js-backnumber-temp-b')
    table.each do |node|
      ankers = node.all('a')
      ankers.each do |anker|
        next if anker.text.blank?
        anker_list.push anker[:href]
      end
    end
    loto_url_list = LinkAnalyzeService.analyze(anker_list)
    factory = LotoFactory.new(loto_url_list)

    # url別にORマッパーにアクセスする
    # url= 1page, elm = n~n+19
    factory.unsave.each do |url, elms|
      session.visit url
      logger.info "url:#{url}"
      rows = session.all(:xpath, '//table[contains(@class, "typeTK")]/tbody/tr')

      rows.each do |row|
        m = /第([０-９0-9]+)回/.match(row.find(:xpath, './/th[contains(@class, "bgf7f7f7")]').text)
        if m.nil?
          logger.warn "miss regexp => #{row.find('th').text}"
          next
        end
        number = m[1].to_i
        elms.each do |elm_hash|
          elm = elm_hash[:item]
          next unless number == elm.number

          elm.number = number

          # td要素の解析(抽選日)
          td_date = row.find(:xpath, './/td[contains(@class, "alnRight")]')
          elm.date = Date.strptime(td_date.text, '%Y年%m月%d日')

          # td要素の解析(結果)
          tds_result = row.all(:xpath, './/td[not(@*) or @class=""]')
          result = []
          tds_result.each do |node|
            result.push node.text
          end
          elm.result = result.to_s.delete('[]\"')

          # td要素(bonus数字の解析)
          tds_bonus = row.all(:xpath, './/td[contains(@class, "alnCenter")]')
          result = []
          tds_bonus.each do |node|
            result.push node.text
          end
          elm.bonus_number = result.to_s.delete('[]\"')

          unless elm.save
            logger.error 'save failed'
            logger.info elm
          end
        end
      end
    end
  end
end
