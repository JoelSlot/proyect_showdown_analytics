with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_moves') }}

),

renamed as (

    select DISTINCT
        pokemon_id::INTEGER AS POKEMON_ID,
        move_id::INTEGER AS MOVE_ID

    from source
    WHERE version_group_id >= 4 AND version_group_id <= 7 
)

select * from renamed