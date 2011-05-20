class Bill
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_protected :uuid
  before_create :gen_uuid
  before_save :update_payments

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

  def update_payments
    self.payments.clear
    owed = {}

    self.people.each do |peep|
      owed[peep.id] = 0
    end

    self.expenses.each do |exp|
      cred_count = exp.creditors.count
      deb_count = exp.debitors.count
      exp.creditors.each do |cred|
        owed[cred.id] += exp.amount / cred_count
      end

      exp.debitors.each do |deb|
        owed[deb.id] -= exp.amount / deb_count
      end
    end

    overall_debitors = owed.reject do |key, val| val >= 0 end.sort_by do |k,v| v end
    overall_creditors = owed.reject do |key, val| val < 0 end.sort_by do |k,v| -v end

    overall_debitors.each do |deb_id, deb_amount|
      overall_creditors.each do |cred_id, cred_amount|
        if owed[deb_id] <= -0.01 and owed[cred_id] >= 0.01
          amt = owed[cred_id]
          amt = owed[deb_id].abs if owed[deb_id].abs < owed[cred_id]

          pay = self.payments.build
          pay.amount = amt
          pay.creditor_id = cred_id
          pay.debitor_id = deb_id
          pay.save

          owed[deb_id] += amt
          owed[cred_id] -= amt
        end
      end
    end
  end
end
