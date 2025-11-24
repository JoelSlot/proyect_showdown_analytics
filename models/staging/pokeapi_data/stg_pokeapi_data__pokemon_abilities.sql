with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_abilities') }}

),

renamed as (

    select
        pokemon_id::INTEGER AS POKEMON_ID,
        ability_id::INTEGER AS ABILITY_ID,
        is_hidden::BOOLEAN AS IS_HIDDEN,
        slot::INTEGER AS ABILITY_SLOT

    from source

)

select * from renamed