Factory.define :user do |f|
  f.name { 'Mr XY' }
  f.sequence(:email) { |n| "mrxy#{n}@example.com" }
  f.password "secret"
end

