module ApplicationHelper
  # Public: returns the link of for website home logo
  #
  # returns a string literal currently - will be changed into image
  def website_logo
    link_to(I18n.t('views.application.website_logo_text'), home_url)
  end
end
