# frozen_string_literal: true
class StaticPagesController < ApplicationController
  def impressum
    render_static_page('impressum')
  end

  def legal_notice
    render_static_page('legal_notice')
  end

  def manual
    render_static_page('manual')
  end

  def about
    render_static_page('about')
  end

  private

  def render_static_page(page)
    @categories = Category.all
    render 'index', locals: { page: page }
  end
end
