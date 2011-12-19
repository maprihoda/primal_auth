# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  password_hash          :string(255)
#  password_salt          :string(255)
#  remember_token         :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  last_login_at          :datetime
#  last_logout_at         :datetime
#  last_activity_at       :datetime
#  login_count            :integer         default(0)
#  last_login_ip          :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#

class User < ActiveRecord::Base
  include Extensions::Authentication

end

