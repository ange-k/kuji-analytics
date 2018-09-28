# parse: リンクの宛先がミニロトか、ロト6か、ロト7かに分別
class LinkAnalyzeService
  BASE_LINK = 'https://www.mizuhobank.co.jp/retail/takarakuji/loto/backnumber/'.freeze
  re_mini  = Regexp.compile('loto([0-9]{4})\.html')
  re_loto6 = Regexp.compile('loto6([0-9]{4})\.html')
  variable = Regexp.compile('detail\.html\?fromto=([0-9]{1,4}_[0-9]{1,4})&type=(loto[6-7]|miniloto)')
  REGEXS = [re_mini, re_loto6, variable].freeze

  def self.analyze(list)
    separate_link = []
    list.each do |link|
      ret = parse(link.sub(BASE_LINK, ''))
      if ret.present?
        ret[:link] = link
        separate_link.push ret
      else
        p "[ERROR] url = #{link}"
      end
    end
    separate_link
  end

  private

  def self.parse(link)
    REGEXS.each_with_index do |re, i|
      m = re.match(link)
      next if m.nil?
      if re == REGEXS.last
        return { data: m[1], type: m[2] }
      end
      type = if i == 0
               'miniloto'
             else
               'loto6'
             end
      return { data: m[1], type: type }
    end
    nil
  end
end