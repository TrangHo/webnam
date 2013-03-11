module Refinery
  module Admin
    class UsersController < Refinery::AdminController

      crudify :'refinery/user',
              :order => 'username ASC',
              :title_attribute => 'username',
              :xhr_paging => true

      before_filter :load_available_plugins_and_roles, :only => [:new, :create, :edit, :update]

      # webnam
      def find_all_users(conditions='')
        if @editing_site
          @users = User.where(conditions).where({:site_id => session[:current_site]}).order('username ASC')
        else
          @users = User.where(conditions).where({:site_id => nil}).order('username ASC')
        end
      end

      # webnam
      def set_editor_fields_when_necessary
        # Enregistrement du site en cas de creation de l'editor d'un site
        # ainsi que des plugins obligatoires
        if @editing_site
          @user.site_id = session[:current_site]
        end
        @selected_plugin_names = ['sites', 'refinery_users', 'products','product_categories',
                                  'coupons','blog_posts','events',
                                  'refinery_images', 'refinery_files','google_calendars',
                                  'refinery_pages', 'refinery_dialogs', 'refinery_i18n']
        params[:user][:plugins] = @selected_plugin_names
      end

      def new
        @user = Refinery::User.new
        @selected_plugin_names = []
      end

      def create
        @user = Refinery::User.new(params[:user].except(:roles))
        @selected_plugin_names = params[:user][:plugins] || []
        @selected_role_names = params[:user][:roles] || []

        set_editor_fields_when_necessary

        if @user.save
          @user.plugins = @selected_plugin_names
          # if the user is a superuser and can assign roles according to this site's
          # settings then the roles are set with the POST data.
          unless current_refinery_user.has_role?(:superuser) and Refinery::Authentication.superuser_can_assign_roles
            @user.add_role(:refinery)
          else
            @user.roles = @selected_role_names.collect { |r| Refinery::Role[r.downcase.to_sym] }
          end

          redirect_to refinery.admin_users_path,
                      :notice => ::I18n.t('created', :what => @user.username, :scope => 'refinery.crudify')
        else
          render :action => 'new'
        end
      end

      def edit
        redirect_unless_user_editable!

        @selected_plugin_names = @user.plugins.collect(&:name)
      end

      def update
        redirect_unless_user_editable!

        # Store what the user selected.
        @selected_role_names = params[:user].delete(:roles) || []
        unless current_refinery_user.has_role?(:superuser) and Refinery::Authentication.superuser_can_assign_roles
          @selected_role_names = @user.roles.collect(&:title)
        end
        @selected_plugin_names = params[:user][:plugins]

        set_editor_fields_when_necessary

        # Prevent the current user from locking themselves out of the User manager
        if current_refinery_user.id == @user.id and (params[:user][:plugins].exclude?("refinery_users") || @selected_role_names.map(&:downcase).exclude?("refinery"))
          flash.now[:error] = ::I18n.t('cannot_remove_user_plugin_from_current_user', :scope => 'refinery.admin.users.update')
          render :edit
        else
          # Store the current plugins and roles for this user.
          @previously_selected_plugin_names = @user.plugins.collect(&:name)
          @previously_selected_roles = @user.roles
          @user.roles = @selected_role_names.collect { |r| Refinery::Role[r.downcase.to_sym] }
          if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
            params[:user].except!(:password, :password_confirmation)
          end

          if @user.update_attributes(params[:user])
            redirect_to refinery.admin_users_path,
                        :notice => ::I18n.t('updated', :what => @user.username, :scope => 'refinery.crudify')
          else
            @user.plugins = @previously_selected_plugin_names
            @user.roles = @previously_selected_roles
            @user.save
            render :edit
          end
        end
      end

    protected

      def find_user_with_slug
        begin
          find_user_without_slug
        rescue ActiveRecord::RecordNotFound
          @user = Refinery::User.all.detect{|u| u.to_param == params[:id]}
        end
      end
      alias_method_chain :find_user, :slug

      def load_available_plugins_and_roles
        @available_plugins = Refinery::Plugins.registered.in_menu.collect { |a|
          { :name => a.name, :title => a.title }
        }.sort_by { |a| a[:title] }

        @available_roles = Refinery::Role.all
      end

      def redirect_unless_user_editable!
        unless current_refinery_user.can_edit?(@user)
          redirect_to(main_app.refinery_admin_users_path) and return
        end
      end
    end
  end
end
