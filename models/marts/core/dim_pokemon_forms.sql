

with

pokemon_forms as (
    select * from {{ref("stg_pokeapi_data__pokemon_forms")}}
)

select * from pokemon_forms