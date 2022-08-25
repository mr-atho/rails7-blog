class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
    @user = User.find(@current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image_name = "default_user.jpg"

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You have signed up successfully"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    
    if @user.update(user_params)
      flash[:notice] = "Your account has been updated successfully"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_path, status: :see_other
  end

  def login_form
    
  end

  def login
    if @user = User.find_by(email: params[:email], password: params[:password])
      session[:current_user_id] = @user.id
      flash[:just_signed_up] = "Welcome to our site"
      redirect_to @user
    else
      @error_message = "Invalid email/password combination"
      @email = params[:email]
      @password = params[:password]

      render :login_form, status: :unprocessable_entity
    end
  end

  def logout
    session[:current_user_id] = nil
    flash[:notice] = "You have logged out successfully"
    redirect_to "/login"
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "Unauthorized access"
      redirect_to users_index_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :image_name)
  end
end
