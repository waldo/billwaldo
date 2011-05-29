Fabricator(:payment) do
end

Fabricator(:payment_abc_0, :from => :payment) do
  amount = 1
end