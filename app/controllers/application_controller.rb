class ApplicationController < ActionController::Base
  # Intentionally empty so that `skip_before_filter :require_login` doesn't
  # crash when there is no `require_login` method otherwise defined.
  def require_login
  end
end
