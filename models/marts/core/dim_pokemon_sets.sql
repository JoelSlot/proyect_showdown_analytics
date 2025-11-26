{{
    config(
        materialized='incremental'
    )
}}

with
new_pokemon_data as (

    select * from {{ ref('stg_showdown_data__pokemon_data') }}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

new_model as (

    select
        POKEMON_DATA_ID,
        BATTLE_ID,
        TRAINER_ID,
        POKEMON_ID,
        ITEM_ID,
        ABILITY_ID,
        LVL,
        sync_date
    FROM new_pokemon_data
)

select * from new_model