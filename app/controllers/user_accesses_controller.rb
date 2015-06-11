class UserAccessesController < ApplicationController
  def create
    email = params[:email]
    if User.where(email: email).count.zero? &&
        Invitation.where(email: email).count.zero? &&
        email.present?
      UserAccessMailer.create_email(email).deliver_now
      render json: :no_content
    else
      render json: {errors: ["Your email is already taken!"]}, status: :unprocessable_entity
    end
  end
end