with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_types') }}

),

renamed as (

    select
        pokemon_id::INTEGER AS POKEMON_ID,
        type_id::INTEGER AS TYPE_ID,
        slot::INTEGER AS SLOT

    from source

)

select * from renamed