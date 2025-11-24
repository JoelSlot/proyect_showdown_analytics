{{
    config(
        materialized='incremental'
    )
}}


with 

source as (

    select * from {{ source('showdown_data', 'pokemon_data') }}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

renamed as (

    select
        battle_id::VARCHAR AS BATTLE_ID,
        trainer::VARCHAR AS TRAINER,
        name::VARCHAR AS POKEMON_NAME,
        base_species::VARCHAR AS POKEMON_BASE_SPECIES,
        item::VARCHAR AS ITEM,
        ability::VARCHAR AS ABILITY,
        lvl::INTEGER AS LVL,
        move_1::VARCHAR AS MOVE_1,
        move_2::VARCHAR AS MOVE_2,
        move_3::VARCHAR AS MOVE_3,
        move_4::VARCHAR AS MOVE_4,
        sync_date

    from source

)

select * from renamed