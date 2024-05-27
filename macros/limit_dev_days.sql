{% macro limit_dev_days(column_name, limit_days = 5000) %}
{%- if target.name == 'dev' -%}
        {{ column_name }} >= date_add(current_date(), interval {{ limit_days }} day)

{%- else -%}
        1=1
{%- endif -%}
{%- endmacro -%}
