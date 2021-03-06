class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    resource.family = Family.create(name: params[:family_name]) unless params[:family_name].empty?
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :first_name, :password, :password_confirmation)
  end

end
