# parse: リンクの宛先がミニロトか、ロト6か、ロト7かに分別
class LinkAnalyzeService
  BASE_LINK = 'https://www.mizuhobank.co.jp/retail/takarakuji/loto/backnumber/'.freeze
  re_mini  = Regexp.compile('loto([0-9]{4})\.html')
  re_loto6 = Regexp.compile('loto6([0-9]{4})\.html')
  re_loto7 = Regexp.compile('detail\.html\?fromto=([0-9]{3-4}_[0-9]{3-4})&type=loto7')
  REGEXS = [re_mini, re_loto6, re_loto7].freeze

  def self.analyze(list)
    separate_link = []
    list.each do |link|
      ret = parse(link.sub(BASE_LINK, ''))
      if ret.present?
        separate_link.push ret
        p ret
        p "type = #{ret[:type]}, data = #{ret[:data]}"
      else
        p "[ERROR] url = #{link}"
      end
    end
    separate_link
  end

  private

  def self.parse(link)
    p link
    REGEXS.each_with_index do |re, i|
      m = re.match(link)
      next if m.nil?
      return { type: i, data: m[1] }
    end
    nil
  end
end