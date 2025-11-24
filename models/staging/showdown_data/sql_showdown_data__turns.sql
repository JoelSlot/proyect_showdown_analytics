{{
    config(
        materialized='incremental'
    )
}}

with match_data as (

    select * from {{ ref('base_showdown_data__match_data') }}
  
),

new_match_data as (

    select * from match_data

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

new_model as (

    select
        BATTLE_ID,
        md5(POV) AS POV_TRAINER_ID,
        TURN_NUMBER,
        
        TO_DATE(BATTLE_DATE, 'MM-DD-YYYY') AS BATTLE_DATE,
        sync_date

    from new_match_data
)

select * from new_model