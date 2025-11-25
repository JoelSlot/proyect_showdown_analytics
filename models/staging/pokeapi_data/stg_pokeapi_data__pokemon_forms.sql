with 

source as (

    select * from {{ ref('base_pokeapi_data__pokemon_forms') }}

),

add_invalid as (
    select * from source
    UNION ALL
    SELECT 
        -1 as POKEMON_ID,
        'nopokemon' as FORM_NAME,
        '' FORM_IDENTIFIER,
        0 AS IS_DEFAULT,
        1 AS FORM_ORDER
)

select * from source