class CreateLotos < ActiveRecord::Migration[5.1]
  def change
    create_table :lotos do |t|
      t.integer :number, null: false            # 開催回
      t.integer :type_number, null: false       # くじ種別
      t.string  :result, null: false            # くじ結果
      t.string  :bonus_number, null: false      # ボーナス数字
      t.date    :date, null: false, index: true # 抽選日
      t.timestamps
    end
    add_index :lotos, [:number, :type_number], :name => 'target_loto_idx', :unique => true
  end
end
