{{
    config(
        materialized='table'
    )
}}

with

stg as (
    select * from {{ref('stg_pokeapi_data__items')}}
)

select * from stg