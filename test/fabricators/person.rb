Fabricator(:person) do
end

Fabricator(:adam, :from => :person) do
  name "adam"
end

Fabricator(:ben, :from => :person) do
  name "benjamin"
end

Fabricator(:charlie, :from => :person) do
  name "charles"
end

Fabricator(:dan, :from => :person) do
  name "daniel"
end

Fabricator(:ed, :from => :person) do
  name "edgar"
end
