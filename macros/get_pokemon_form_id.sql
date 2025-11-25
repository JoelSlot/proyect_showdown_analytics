{% macro get_pokemon_form_id(name_value) %}

(
    with forms as (
        select * from {{ ref('base_pokeapi_data__pokemon_forms') }}
    ),
    first_match as (
        select
            POKEMON_ID
        from forms 
        where replace({{name_value | string}}, '-', '') = replace(FORM_NAME, '-', '')
        ORDER BY FORM_ORDER
        limit 1
    ),
    second_match as (
        select
            POKEMON_ID
        from forms
        where replace({{name_value | string}}, '-', '') = replace(replace(FORM_NAME, concat('-', form_identifier), ''), '-', '')
        ORDER BY FORM_ORDER
        limit 1
        
    )
    select
        coalesce(
            (select POKEMON_ID from first_match),
            (select POKEMON_ID from second_match)
        ) as POKEMON_ID
)

{% endmacro %}
