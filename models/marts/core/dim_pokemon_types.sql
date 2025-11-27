{{
    config(
        materialized='table'
    )
}}

with
pokemon_types as (

    select * from {{ ref('stg_pokeapi_data__pokemon_types') }}

),

new_model as (

    select
        *
    FROM pokemon_types
)

select * from new_model