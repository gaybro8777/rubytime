require Merb.root / "lib/rubytime/authenticated_system"

class Application < Merb::Controller
  include Utype::AuthenticatedSystem
  
  protected
  
  def admin_required
    throw(:halt, :access_denied) unless current_user.is_admin?
  end
end