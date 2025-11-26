

with

pokemon_forms as (
    select * from {{ref("stg_pokeapi_data__moves")}}
)

select * from pokemon_forms