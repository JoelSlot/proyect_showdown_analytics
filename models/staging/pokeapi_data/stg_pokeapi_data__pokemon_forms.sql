with 

source as (

    select * from {{ ref('base_pokeapi_data__pokemon_forms') }}

),
form_generations as (
    select * from {{ ref('base_pokeapi_data__pokemon_form_generations') }}
),

gen_4_only as(
    SELECT
        POKEMON_ID,
        FORM_NAME,
        FORM_IDENTIFIER,
        IS_DEFAULT,
        FORM_ORDER
    FROM source f
        LEFT JOIN form_generations g ON f.POKEMON_FORM_ID = g.POKEMON_FORM_ID
    WHERE GENERATION_ID = 4
),

add_invalid as (
    select * from gen_4_only
    QUALIFY ROW_NUMBER() OVER ( --ignore later forms with same pokemon_id
            PARTITION BY POKEMON_ID
            ORDER BY FORM_ORDER ASC
        ) = 1
    UNION ALL
    SELECT
        -1 as POKEMON_ID,
        'nopokemon' as FORM_NAME,
        '' FORM_IDENTIFIER,
        0 AS IS_DEFAULT,
        1 AS FORM_ORDER
)

select * from add_invalid