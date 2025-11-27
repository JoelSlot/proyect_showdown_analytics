{{
    config(
        materialized='table'
    )
}}

with
pokemon_stats as (

    select * from {{ ref('stg_pokeapi_data__pokemon_stats') }}

),

new_model as (

    select
        *
    FROM pokemon_stats
)

select * from new_model