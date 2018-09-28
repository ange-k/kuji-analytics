class LotoFactory
  attr_reader :save

  def initialize(list)
    # 分解
    @unsave = []
    @save = []
    list.each do |loto_data|
      number = loto_data[:data]
      type = loto_data[:type]
      range = parse(number)

      range.each do |number|
        type_number = Loto.cnv_type_number(type)
        elm = Loto.find_by(number: number, type_number: type_number)
        if elm.nil?
          @unsave.push({ item: Loto.new(number: number, type_number: type_number), url: loto_data[:link] })
        else
          @save.push({ item: elm, url: loto_data[:link] })
        end
      end
    end
  end

  def unsave
    @unsave.group_by do |node|
      node[:url]
    end
  end

  private

  def parse(number)
    if number.include?('_')
      str = number.split('_')
      b = str[0].to_i
      e = str[1].to_i
    else
      b = number.to_i
      e = b + 19
    end
    b..e
  end
end
