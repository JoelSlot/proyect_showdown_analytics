{{
    config(
        materialized='incremental'
    )
}}

with

battles as (
    select * from {{ref("stg_showdown_data__battles")}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

new_model as (
    select
        BATTLE_ID,
        FORMAT_ID,
        IS_RATED,
        ELO,
        TOTAL_TURNS,
        WINNER_ID,
        CONCAT(BATTLE_ID,'-', WINNER_ID) AS WINNER_TEAM_ID,
        LOSER_ID,
        CONCAT(BATTLE_ID,'-', LOSER_ID) AS LOSER_TEAM_ID,
        BATTLE_DATE,
        SYNC_DATE
    from
        battles
)

select * from new_model
