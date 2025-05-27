module PagyHelper
  def pagy_nav_tailwind(pagy)
    html = +%(<nav class="flex items-center justify-center mt-8"><ul class="inline-flex -space-x-px">)
    html << pagy_link_proc(pagy, '&laquo;', 'px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700')
    pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
      when Integer # page link
        pagy_link_proc(pagy, item, 'px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700')
      when String # current page
        %(<span class="px-3 py-2 leading-tight text-indigo-600 bg-indigo-100 border border-gray-300">#{item}</span>)
      when :gap # gap in series
        %(<span class="px-3 py-2 leading-tight text-gray-400 bg-gray-100 border border-gray-300">&hellip;</span>)
      end
    end
    html << pagy_link_proc(pagy, '&raquo;', 'px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700')
    html << %(</ul></nav>)
  end

  private

  def pagy_link_proc(pagy, text, classes)
    if text.is_a?(Integer)
      %(<li>#{link_to text, url_for(request.params.merge(page: text)), class: classes}</li>)
    else
      %(<li>#{link_to text, url_for(request.params.merge(page: text)), class: classes, 'aria-label': "Goto page #{text}"}</li>)
    end
  end
end 