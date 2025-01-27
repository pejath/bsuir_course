class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :purchasable, polymorphic: true, null: false
      t.string :status

      t.timestamps
    end
  end
end
