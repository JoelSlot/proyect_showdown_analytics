{{
    config(
        materialized='table'
    )
}}

with

stg as (
    select * from {{ref('stg_pokeapi_data__move_damage_classes')}}
)

select * from stg