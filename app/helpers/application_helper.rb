module ApplicationHelper
  def to_page(position,pagesize)
    page = (position / pagesize) + 1
    page = nil if page == 1
    page
  end
end
