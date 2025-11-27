{% test is_positive_not_null_not_zero(model, column_name) %}

with validation as (

    select
        {{ column_name }} as positive_field

    from {{ model }}

),

validation_errors as (

    select
        positive_field

    from validation
    -- if this is true, then even_field is actually odd!
    where positive_field <= 0 or positive_field IS NULL

)

select *
from validation_errors

{% endtest %}