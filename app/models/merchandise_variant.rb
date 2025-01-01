class MerchandiseVariant < ApplicationRecord
  belongs_to :merchandise
  
  validates :size, presence: true, if: :requires_size?
  validates :color, presence: true, if: :requires_color?
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

  def requires_size?
    merchandise.merchandise_type == 'tshirt'
  end

  def requires_color?
    merchandise.merchandise_type == 'tshirt'
  end
end 