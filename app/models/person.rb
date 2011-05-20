class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :finished_flag, :type => Boolean, :default => false
  
  has_and_belongs_to_many :bills
end
