require_relative '../bomber.rb'

Rspec.describe Bomber do
  bomber = Bomber.new(10, 5)
  expect(bomber).to_eq 1
end
