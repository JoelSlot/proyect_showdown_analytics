{{
    config(
        materialized='incremental'
    )
}}

with

fct_sets as (
    select * from {{ref("fct_pokemon_sets")}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

battles as (
    select * from {{ref("fct_turns")}}
    WHERE TURN_NUMBER = 0
    {% if is_incremental() %}

    AND sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

new_fact as (
    select DISTINCT
        F.POKEMON_DATA_ID,
        B.FORMAT_ID,
        CONCAT(F.BATTLE_ID, '-', F.TRAINER_ID) AS TEAM_ID,
        F.TRAINER_ID,
        F.POKEMON_ID,
        F.ITEM_ID,
        F.ABILITY_ID,
        F.LVL,
        CASE
            WHEN B.IS_WINNER THEN 'WIN'
            ELSE 'LOSS'
        END AS BATTLE_RESULT,
        B.ELO,
        F.sync_date
    from fct_sets F
        LEFT JOIN battles B ON F.BATTLE_ID = B.BATTLE_ID AND B.POV_TRAINER_ID = F.TRAINER_ID
)

SELECT * FROM new_fact