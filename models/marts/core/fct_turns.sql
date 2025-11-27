{{
    config(
        materialized='incremental'
    )
}}

with

turns as (
    select * from {{ref("stg_showdown_data__turns")}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

battles as (
    select * from {{ref("stg_showdown_data__battles")}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

new_model as(
    select 
        T.BATTLE_ID,
        B.FORMAT_ID,
        B.IS_RATED,
        B.ELO,
        T.POV_TRAINER_ID,
        CASE WHEN T.POV_TRAINER_ID = B.WINNER_ID THEN 1
        ELSE 0 END::BOOLEAN AS IS_WINNER,
        T.TURN_NUMBER,
        T.POKEMON_ID,
        T.POKEMON_HP,
        T.POKEMON_STATUS,
        T.POKEMON_EFFECT,
        T.LAST_MOVE_ID,
        T.NEXT_ACTION,
        T.NEXT_MOVE_ID,
        B.BATTLE_DATE,
        T.sync_date
    from turns T
        LEFT JOIN battles B ON B.BATTLE_ID = T.BATTLE_ID
)

select * from new_model