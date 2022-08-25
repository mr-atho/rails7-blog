class ArticlesController < ApplicationController
  before_action :authenticate_user, {only: [:new, :edit, :update]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @articles = Article.all.where(status: "public").order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
    @user =  @article.user
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = @current_user.id

    if @article.save
      flash[:notice] = "Article successfully created"
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    
    if @article.update(article_params)
      flash[:notice] = "Article successfully edited"
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Article successfully deleted"
    redirect_to @article, status: :see_other
  end

  def ensure_correct_user
    @article = Article.find_by(id: params[:id])
    
    if @article.user_id != @current_user.id
      flash[:notice] = "Unauthorized access"
      redirect_to @article
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :content, :status).merge(user_id: @current_user.id)   
  end

end
