{{
    config(
        materialized='table'
    )
}}

with
pokemon_type_efficacy as (

    select * from {{ ref('stg_pokeapi_data__pokemon_type_efficacy') }}

),

new_model as (

    select
        *
    FROM pokemon_type_efficacy
)

select * from new_model