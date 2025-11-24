with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_forms') }}

),

renamed as (

    select
        POKEMON_ID::INTEGER AS POKEMON_ID,
        identifier::VARCHAR AS FORM_NAME,
        form_identifier::VARCHAR AS FORM_IDENTIFIER,
        is_default::BOOLEAN AS IS_DEFAULT,
        form_order::INTEGER AS FORM_ORDER
    FROM source
)

select * from renamed