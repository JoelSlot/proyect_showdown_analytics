with

abilities as (
    select * from {{ref('base_pokeapi_data__abilities')}}
),


effects as (
    select * from {{ref('base_pokeapi_data__ability_effects')}}
),

names as (
    select * from {{ref('base_pokeapi_data__ability_names')}}
),

new_model as(
    select
        a.ABILITY_ID,
        a.ABILITY_IDENTIFIER,
        n.ABILITY_NAME,
        e.ABILITY_EFFECT
    FROM abilities a
        LEFT JOIN effects e ON a.ABILITY_ID = e.ABILITY_ID
        LEFT JOIN names n ON a.ability_id = n.ABILITY_ID
)

select * from new_model