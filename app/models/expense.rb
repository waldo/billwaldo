# encoding: utf-8
class Expense
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :description, :type => String
  field :amount, :type => BigDecimal

  embedded_in :bill

  has_and_belongs_to_many :creditors, :class_name => "Person"
  has_and_belongs_to_many :debitors, :class_name => "Person"
  
  accepts_nested_attributes_for :creditors, :allow_destroy => true
  accepts_nested_attributes_for :debitors, :allow_destroy => true

  def creditors_list
    listize(self.creditors)
  end

  def debitors_list
    listize(self.debitors)
  end

  protected
  def listize(list, separator = ", ")
    list.map(&:name).join(separator)
  end
end
