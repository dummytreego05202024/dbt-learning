{% macro clean_stale_models(database=target.database, schema=target.schema, days=7, dry_run=True) %}
    
    {% set get_drop_commands_query %}
        SELECT
        drop_type,
        'DROP ' || drop_type || ' DBT-LEARN-05202024.' || table_schema || '.' || table_name || ';' as drop_query
        FROM (
            SELECT
                table_name,
                table_schema,
                CASE 
                WHEN table_type = 'VIEW' THEN 'VIEW'
                ELSE 'TABLE'
                END as drop_type,
                creation_time
            FROM `dbt-learn-05202024.dbt_wyan.INFORMATION_SCHEMA.TABLES`
            WHERE table_schema = 'dbt_wyan'
            and CAST(creation_time AS DATETIME) <= CURRENT_DATETIME() - INTERVAL {{days}} DAY   )
    {% endset %}

    {{ log('\nGenerating cleanup queries...\n', info=True) }}
    {% set result = run_query(get_drop_commands_query) %}
    {% if result and result.columns[1].values() %}
        {% set drop_queries = result.columns[1].values() %}

        {% for query in drop_queries %}
            {% if dry_run %}
                {{ log(query, info=True) }}
            {% else %}
                {{ log('Dropping object with command: ' ~ query, info=True) }}
                {% do run_query(query) %}
            {% endif %}
        {% endfor %}
    {% else %}
        {{ log('No stale models found to drop.', info=True) }}
    {% endif %}
    
{% endmacro %}
