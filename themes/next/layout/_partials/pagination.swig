{% if page.prev or page.next %}
  <nav class="pagination">
    {{
      paginator({
        prev_text: 'Page Up',
        next_text: 'Page Down',
        mid_size: 1
      })
    }}
  </nav>
{% endif %}
