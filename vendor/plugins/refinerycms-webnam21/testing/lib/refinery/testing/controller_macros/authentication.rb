module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send(:include, Devise::TestHelpers)
        end

        def login_user
          let(:user) { FactoryGirl.create(:user) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in user
          end
        end

        def login_refinery_user
          let(:refinery_user) { FactoryGirl.create(:refinery_user) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_user
          end
        end

        def login_refinery_superuser
          let(:refinery_superuser) { FactoryGirl.create(:refinery_superuser) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_superuser
          end
        end

        def login_refinery_translator
          let(:refinery_translator) { FactoryGirl.create(:refinery_translator) }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in refinery_translator
          end
        end
      end
    end
  end
end
