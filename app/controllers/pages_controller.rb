# frozen_string_literal: true

class PagesController < InheritedResources::Base
  http_basic_authenticate_with(
    name: 'rbbastos',
    password: '1234',
    except: :permalink
  )

  def page_params
    params.require(:page).permit(:title, :content, :permalink)
  end

  def permalink
    @page = Page.find_by_permalink(params[:permalink])

    if @page
      # test if find_by_permalink worked properly
      render :show # /app/views/pages/show.html.erb
    else
      # grab error in find_by_permalink
      redirect_to root_path
    end
  end
end
