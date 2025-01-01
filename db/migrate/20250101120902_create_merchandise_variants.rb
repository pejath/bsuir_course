class CreateMerchandiseVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchandise_variants do |t|
      t.references :merchandise, null: false, foreign_key: true
      t.string :size
      t.string :color
      t.integer :stock, default: 0, null: false

      t.timestamps
    end

    add_index :merchandise_variants, [:merchandise_id, :size, :color], unique: true
  end
end 