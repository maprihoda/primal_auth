namespace :users do

  desc 'Delete unconfirmed users'
  task :delete_unconfirmed => :environment do
    num_deleted = User.delete_unconfirmed
    puts num_deleted > 0 ? "Deleted #{num_deleted} #{ num_deleted == 1 ? 'user' : 'users'}" : "0 users deleted"
  end

end

