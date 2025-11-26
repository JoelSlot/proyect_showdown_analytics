{{
    config(
        materialized='incremental'
    )
}}

with match_data as (

    select * from {{ ref('base_showdown_data__match_data') }}
  
),

new_match_data as (

    select POV, MAX(sync_date) as sync_date from match_data 

    {% if is_incremental() %}
        where sync_date > (select max(sync_date) from {{ this }})
    {% endif %}

    GROUP BY POV

    {% if is_incremental() %}
        having POV NOT IN (select trainer_name from {{ this }})
    {% endif %}

),

new_model as (

    select
        md5(POV) AS TRAINER_ID,
        POV AS TRAINER_NAME,
        sync_date

    from new_match_data

)

select * from new_model