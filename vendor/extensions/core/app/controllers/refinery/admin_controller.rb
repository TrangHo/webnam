# Filters added to this controller apply to all controllers in the refinery backend.
# Likewise, all the methods added will be available for all controllers in the refinery backend.
module Refinery
  class AdminController < ::ActionController::Base
    include ::Refinery::ApplicationController
    helper ApplicationHelper
    helper Refinery::Core::Engine.helpers
    include Refinery::Admin::BaseController

    #webnam
    before_filter :set_site_mode

    def set_site_mode
      @editing_site = session[:current_site].present? && (session[:current_site] != -1)
    end

  end
end
