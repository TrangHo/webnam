# encoding: utf-8

Refinery::I18n.configure do |config|
  # config.enabled = true

  # config.default_locale = :en

  # config.current_locale = :en

  # config.default_frontend_locale = :en

  config.frontend_locales = [:en, :vn, :fr]

  config.locales = {:en=>"English", :fr=>"Français", :vn => "Vietnamese", :nl=>"Nederlands", :"pt-BR"=>"Português", :da=>"Dansk", :nb=>"Norsk Bokmål", :sl=>"Slovenian", :es=>"Español", :it=>"Italiano", :de=>"Deutsch", :lv=>"Latviski", :ru=>"Русский", :sv=>"Svenska", :pl=>"Polski", :"zh-CN"=>"Simplified Chinese", :"zh-TW"=>"Traditional Chinese", :el=>"Ελληνικά", :rs=>"Srpski", :cs=>"Česky", :sk=>"Slovenský", :ja=>"日本語", :bg=>"Български"}
end
