{{
    config(
        materialized='table'
    )
}}

with

pokemon_abilities as (
    select * from {{ref("stg_pokeapi_data__abilities")}}
)

select * from pokemon_abilities