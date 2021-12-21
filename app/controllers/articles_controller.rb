class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1
    if session[:page_views] <= 3
      article = find_article
      render json: article
    else session[:page_views] > 3
      page_view_limit_reached
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def page_view_limit_reached
    render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
  end
  

  def find_article
    Article.find(params[:id])
  end
  

end
