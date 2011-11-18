every 1.day, :at => '0:01 am' do
  rake 'users:delete_unconfirmed'
end

