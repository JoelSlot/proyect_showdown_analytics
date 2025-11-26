{{
    config(
        materialized='incremental'
    )
}}

with

formats as (
    select * from {{ref("stg_showdown_data__formats")}}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
)

select * from formats