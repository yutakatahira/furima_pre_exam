class Item < ApplicationRecord
  enum condition:{brand_new: 0, unused: 1, inconspicuous: 2, kind_of: 3, dirt: 4, old: 5}
  enum delivery_fee_payer:{seller: 0, buyer: 1}
  enum delivery_method:{Undecided: 0, merukari: 1, yu_mail: 2, letterpack: 3, post: 4, yamato: 5, yu_pack: 6, clickpost: 7, yu_packet: 8}
  enum delivery_days:{short: 0, middle: 1, long: 2}
  enum deal:{sale: 0, sold_out: 1}

  validates :name, :price, :detail, :condition, :delivery_fee_payer, :delivery_method, :prefecture_id, :delivery_days, :deal, presence: true
  validates :price, numericality:{greater_than_or_equal_to: 50,less_than_or_equal_to: 9999999}
  validates :item_images, length: { minimum: 1, message: "is none"}

  has_many :item_images, dependent: :destroy

  belongs_to :category
  belongs_to :user
  accepts_nested_attributes_for :item_images, allow_destroy: true

  scope :search_category, -> (category_id) {includes(:item_images).where(category_id: category_id)}

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
end
