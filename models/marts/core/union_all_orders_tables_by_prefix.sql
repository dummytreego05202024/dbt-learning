{{
    config(
        materialized='table'
    )
}}

{{ union_tables_by_prefix(

      database='dbt-learn-05202024',
      schema='dbt_wyan',
      prefix='orders__'
        
      )
      
  }}