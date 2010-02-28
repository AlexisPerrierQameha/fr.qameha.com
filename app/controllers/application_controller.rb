# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_user_language
  before_filter :right_site

  def set_user_language
    session[:lang] =  params[:lang]              if params[:lang]
    session[:lang] ||=  client_browser_language
    @select_langages = select_langages
  end

  def right_site
    if client_browser_language == "fr" and !request.subdomains.include("fr")
      @right_site = "redirecting to fr.qameha.com"
    end
    if client_browser_language == "en" and request.subdomains.include("fr")
      @right_site = "redirecting to qameha.com"
    end
  end

  private
  def client_browser_language

    unless request.env['HTTP_ACCEPT_LANGUAGE'].blank?
      user_agent = request.env['HTTP_ACCEPT_LANGUAGE'].downcase
      if user_agent =~ /fr/i
        "fr"
      else
        "en"
      end
    else
      "en"
    end
  end

  def select_langages
    langages = {
      "English" =>"en",
      "Français" => "fr",
    }
    sl = ""
    langages.each do |l,v|
      if (session[:lang] == v)
        sl << "<option selected value = '" + v + "'>" + l + "</option>"
      else
        sl << "<option value = '" + v + "'>" + l + "</option>"
      end
    end
    sl
  end

end



