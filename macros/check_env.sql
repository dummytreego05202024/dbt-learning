{% macro check_environment() %}
    {{ log("Current environment: " ~ target.name, info=True) }}
    {{ return(target.name) }}
{% endmacro %}
