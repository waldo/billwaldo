class Expense
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :amount, :type => Float

  embedded_in :bill

  has_and_belongs_to_many :creditors, :class_name => "Person"
  has_and_belongs_to_many :debitors, :class_name => "Person"
  
  accepts_nested_attributes_for :creditors, :allow_destroy => true
  accepts_nested_attributes_for :debitors, :allow_destroy => true
end
