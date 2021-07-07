class CreateAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_table :analyses do |t|
      t.integer :number, null: false                # 親数字
      t.integer :pair, null: false                  # ペア
      t.integer :type_number, null: false           # くじ種別
      t.integer :total, null: false, default: 0     # 合計
      t.integer :year, null: false, index: true     # 抽選年
      t.integer :month, null: false, index: true    # 抽選月
      t.timestamps
    end
    add_index :analyses, [:number, :pair, :type_number, :year, :month], :name => 'num_unique_idx'
    add_index :analyses, [:number, :pair, :type_number, :month], :name => 'target_num_month_idx'
    add_index :analyses, [:number, :pair, :type_number],:name => 'target_num_pair_idx'
    add_index :analyses, [:number, :pair],:name => 'target_num_pair_all_idx'
  end
end
