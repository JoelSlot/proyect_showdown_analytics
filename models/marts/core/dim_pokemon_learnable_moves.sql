{{
    config(
        materialized='table'
    )
}}
with
pokemon_moves as (

    select * from {{ ref('stg_pokeapi_data__pokemon_moves') }}

),

new_model as (

    select
        POKEMON_ID,
        MOVE_ID
    FROM pokemon_moves
)

select * from new_model