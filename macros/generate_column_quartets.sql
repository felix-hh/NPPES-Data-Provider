{% macro generate_column_quartets(prefix1, prefix2, prefix3, prefix4, n) %}
    {% for i in range(1, n+1) %}
        ("{{ prefix1 }}{{ i }}", "{{ prefix2 }}{{ i }}", "{{ prefix3 }}{{ i }}", "{{ prefix4 }}{{ i }}") as '{{ i }}'{% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
