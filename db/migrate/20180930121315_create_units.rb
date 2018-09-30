class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.integer :number, null: false                # 開催回
      t.integer :type_number, null: false           # くじ種別
      t.integer :unit, null: false                  # 結果(単数)
      t.boolean :bonus, null: false, default: false # ボーナス数字かどうか
      t.integer :year, null: false, index: true     # 抽選年
      t.integer :month, null: false, index: true    # 抽選月
      t.integer :day, null: false, index: true      # 抽選日
      t.timestamps
    end

    add_index :units, [:number, :type_number], :name => 'target_units_idx'
  end
end
