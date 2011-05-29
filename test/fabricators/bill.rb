a = Fabricate(:adam)
b = Fabricate(:ben)
c = Fabricate(:charlie)
d = Fabricate(:dan)
e = Fabricate(:ed)

Fabricator(:bill) do
end

Fabricator(:abc, :from => :bill) do
  name "abc"
  after_create do |bill|
    bill.people << [a, b, c, d, e]
    bill.expenses << Fabricate.build(:expense) do
      after_create do |e|
        e.amount = 5
        e.description = "soup"
        e.creditors << a
        e.debitors << [a, b, c, d, e]
      end
    end
  end
end