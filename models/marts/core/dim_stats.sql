{{
    config(
        materialized='table'
    )
}}

with

stats_table as (
    select * from {{ref('stg_pokeapi_data__stats')}}
)

select * from stats_table