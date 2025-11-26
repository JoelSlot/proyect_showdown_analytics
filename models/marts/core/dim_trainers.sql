{{
    config(
        materialized='incremental'
    )
}}

with

trainers as (
    select * from {{ref("stg_showdown_data__trainers")}}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
)

select * from trainers