module Extensions
  module Authentication
    extend ActiveSupport::Concern

    included do
      attr_accessor :password

      attr_accessible :name, :email, :password, :password_confirmation

      validates :name, :presence => true, :length => { :maximum => 70 }

      # user will login with email and password
      validates :email,
        :presence => true,
        :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
        :uniqueness => { :case_sensitive => false, :if => lambda { |user| !user.confirmed_at.nil? } }

      # user will be able to edit her profile without providing password
      validates_presence_of :password, :on => :create
      validates_confirmation_of :password, :allow_blank => true
      validates_length_of :password, :within => 6..40, :allow_blank => true

      before_save :prepare_password, :downcase_email
      before_create { generate_token(:remember_token) }
      before_create { generate_token(:confirmation_token) unless authenticated_with_omniauth? }
      after_create { send_confirmation_instructions_and_save unless authenticated_with_omniauth? }
    end

    module ClassMethods
      def authenticate(email, pass)
        user = where('email = ? AND confirmed_at IS NOT NULL', email.downcase).first
        return user if user && user.password_hash == user.encrypt_password(pass)
      end

      def delete_unconfirmed
        ids = User.where('confirmed_at IS NULL AND confirmation_sent_at < ?', 24.hour.ago).select(:id).map(&:id)
        User.delete(ids) # NB: we don't have any destory callback nor dependant associations so this is OK (and fast)

        # TODO: if, in the future, there are callbacks and/or associations on the User model,
        # we should _destroy_ the objects rather than deleting them via raw sql
      end

      def create_with_omniauth(auth)
        user = new
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"] if auth["info"]["email"].present?
        user.save!(:validate => false)
        user
      end
    end

    module InstanceMethods
      def encrypt_password(pass)
        BCrypt::Engine.hash_secret(pass, password_salt)
      end

      def reset_remember_token
        generate_token(:remember_token)
      end

      def reset_remember_token_and_save
        reset_remember_token
        save!(:validate => false)
      end

      def send_password_reset
        generate_token(:password_reset_token)
        self.password_reset_sent_at = Time.zone.now
        save!
        UserMailer.password_reset(self).deliver
      end

      def send_confirmation_instructions
        generate_token(:confirmation_token)
        self.confirmation_sent_at = Time.zone.now
        UserMailer.confirmation_instructions(self).deliver
      end

      def send_confirmation_instructions_and_save
        send_confirmation_instructions
        save!
      end

      def confirm!
        self.confirmed_at = Time.zone.now
        save!(:validate => false)
      end

      def confirmed?
        !!confirmed_at
      end

      def track_on_login(request)
        self.last_login_at = Time.zone.now
        self.last_login_ip = request.remote_ip
        self.login_count += 1
      end

      def track_on_logout
        self.last_logout_at = Time.zone.now
      end


      def authenticated_with_omniauth?
        uid && provider
      end

      def logout(cookies)
        track_on_logout
        reset_remember_token_and_save
        cookies.delete(:remember_token)
      end

      private

      def prepare_password
        unless password.blank?
          self.password_salt = BCrypt::Engine.generate_salt
          self.password_hash = encrypt_password(password)
        end
      end

      def downcase_email
        email.downcase! if email.present?
      end

      def generate_token(column)
        begin
          self[column] = SecureRandom.urlsafe_base64
        end while User.exists?(column => self[column])
      end
    end
  end
end

