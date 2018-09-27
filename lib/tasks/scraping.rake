namespace :scraping do
  desc "mizuhoをスクレイピング"

  task exec: :environment do
    require 'capybara/poltergeist'

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end
    session = Capybara::Session.new(:poltergeist)
    session.visit "https://www.mizuhobank.co.jp/retail/takarakuji/loto/backnumber/index.html"

    puts "status=#{session.status_code}"

    anker_list = []

    table = session.all('.js-backnumber-temp-b')
    table.each do |node|
      ankers = node.all('a')
      ankers.each do |anker|
        next if anker.text.blank?
        anker_list.push anker[:href]
      end
    end
    p LinkAnalyzeService.analyze(anker_list)
  end
end
