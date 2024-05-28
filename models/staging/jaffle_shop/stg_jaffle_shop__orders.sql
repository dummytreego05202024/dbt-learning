select '{{ target.name }}' as environment,
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from {{ source('jaffle_shop', 'orders') }}
---- where {{ limit_dev_days('order_date', -6000) }}
