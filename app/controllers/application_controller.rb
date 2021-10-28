class ApplicationController < ActionController::API
  before_action :authenticate_user

  attr_reader :current_user

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ') if header
    
    if !header || header.first != "Bearer"|| header.size != 2
     render json: { errors: 'Token JWT vazio.'}, status: :unauthorized
    else
      begin
        @decoded = JsonWebToken.decode(header.last)
        @current_user = User.where(email: @decoded[:email]).find(@decoded[:id])
      rescue 
        render json: { errors: 'Token JWT inválido.' }, status: :unauthorized
      end
    end
  end
end
