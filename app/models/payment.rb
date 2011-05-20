# encoding: utf-8
class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, :type => Float
  field :paid_flag, :type => Boolean, :default => false

  embedded_in :bill

  belongs_to_related :creditor, :class_name => "Person"
  belongs_to_related :debitor, :class_name => "Person"
end
