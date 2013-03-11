module Refinery
  class SessionsController < Devise::SessionsController
    helper Refinery::Core::Engine.helpers
    layout 'refinery/layouts/login'

    before_filter :clear_unauthenticated_flash, :only => [:new]

    def create
      super

      # webnam
      session[:current_site] = current_refinery_user.site_id

    rescue ::BCrypt::Errors::InvalidSalt, ::BCrypt::Errors::InvalidHash
      flash[:error] = ::I18n.t('password_encryption', :scope => 'refinery.users.forgot')
      redirect_to refinery.new_refinery_user_password_path
    end

  protected

    # We don't like this alert.
    def clear_unauthenticated_flash
      if flash.keys.include?(:alert) and flash.any?{|k, v|
        ['unauthenticated', ::I18n.t('unauthenticated', :scope => 'devise.failure')].include?(v)
      }
        flash.delete(:alert)
      end
    end

  end
end
