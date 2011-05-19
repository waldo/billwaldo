class Bill
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_protected :uuid
  before_create :gen_uuid

  field :uuid, :type => String
  field :name, :type => String
  has_and_belongs_to_many :people
  embeds_many :expenses
  embeds_many :payments

  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :expenses, :allow_destroy => true
  accepts_nested_attributes_for :payments, :allow_destroy => true

  protected
  def gen_uuid
    self.uuid = SecureRandom.hex
  end
end
