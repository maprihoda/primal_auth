module ApplicationHelper
  def title(page_title)
    content_for(:title) { h(page_title.to_s) }
  end

  def user_navigation
    if block_given?
      n = controller.controller_name
      unless n == 'sessions' || n == 'users' || n == 'confirmations'
        yield
      end
    end
  end
end

