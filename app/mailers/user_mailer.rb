class UserMailer < Merb::MailController
  def welcome
    @user = params[:user]
    @url = Rubytime::CONFIG[:site_url]
    render_mail
  end
  
  def new_password
    @user = params[:user]
    @url = Rubytime::CONFIG[:site_url]
    render_mail
  end
end
