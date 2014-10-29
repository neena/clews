class StaticController < ApplicationController
  skip_authorization_check
  def permission_denied
  end
end
