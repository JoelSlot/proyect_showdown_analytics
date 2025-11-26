with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_form_generations') }}

),

renamed as (

    select
        POKEMON_FORM_ID::INTEGER AS POKEMON_FORM_ID,
        GENERATION_ID::INTEGER AS GENERATION_ID
    FROM source
)

select * from renamed