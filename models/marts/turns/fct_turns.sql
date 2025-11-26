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

new_model as(
    select 
        T.BATTLE_ID,
        T.POV_TRAINER_ID,
        T.TURN_NUMBER,
        T.POKEMON_ID AS POV_POKEMON_ID,
        T.POKEMON_HP AS POV_POKEMON_HP,
        O.POKEMON_ID AS OPP_POKEMON_ID,
        O.POKEMON_HP AS OPP_POKEMON_HP,
        T.LAST_MOVE_ID,
        T.NEXT_ACTION,
        T.NEXT_MOVE_ID,
        T.sync_date
    from turns T
        LEFT JOIN turns O ON
            T.BATTLE_ID = O.BATTLE_ID AND
            T.TURN_NUMBER = O.TURN_NUMBER AND
            T.POV_TRAINER_ID != O.POV_TRAINER_ID
)

select * from new_model