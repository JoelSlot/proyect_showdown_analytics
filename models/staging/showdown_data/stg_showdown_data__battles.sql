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

winners as (
    select * from new_match_data
    where RESULT = 'WIN' AND TURN_NUMBER = 0
),

new_model as (

    select
        BATTLE_ID,
        md5(FORMAT) AS FORMAT_ID,
        CASE WHEN ELO = 'Unrated' THEN 0
        ELSE 1 END::BOOLEAN AS IS_RATED,
        CASE WHEN ELO = 'Unrated' THEN -1
        ELSE ELO
        END::INTEGER AS ELO,
        md5(POV) AS WINNER_ID,
        md5(OPPONENT) AS LOSER_ID,
        TOTAL_TURNS,
        TO_DATE(BATTLE_DATE, 'MM-DD-YYYY') AS BATTLE_DATE,
        sync_date

    from winners
)

select * from new_model