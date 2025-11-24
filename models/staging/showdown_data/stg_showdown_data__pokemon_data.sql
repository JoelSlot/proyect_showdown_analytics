{{
    config(
        materialized='incremental'
    )
}}

with moves as (

    select * from {{ ref('base_pokeapi_data__moves') }}
),

forms as (
    select * from {{ ref('base_pokeapi_data__pokemon_forms') }}
),

pokemon_data as (

    select * from {{ ref('base_showdown_data__pokemon_data') }}
  
),
items as (
    select * from {{ ref('base_pokeapi_data__items')}}
),
abilities as (
    select * from {{ref('base_pokeapi_data__abilities')}}
),
new_pokemon_data as (

    select * from pokemon_data

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

first_form_match as (

    select
        d.BATTLE_ID,
        md5(d.TRAINER) AS TRAINER_ID,
        f.POKEMON_ID,
        d.POKEMON_NAME, --for if no pokemon_id was matched
        i.ITEM_ID,
        a.ABILITY_ID,
        d.LVL,
        d.MOVE_1,
        d.MOVE_2,
        d.MOVE_3,
        d.MOVE_4,
        d.sync_date
    FROM new_pokemon_data d
        LEFT JOIN forms f ON replace(d.POKEMON_NAME, '-', '') = replace(f.FORM_NAME, '-', '')
        LEFT JOIN items i ON d.item = i.ITEM_IDENTIFIER
        LEFT JOIN abilities a ON d.ABILITY = a.ABILITY_IDENTIFIER
),

base_forms as (
        select DISTINCT
            POKEMON_ID,
            replace(FORM_NAME, concat('-', form_identifier), '') AS BASE_FORM
        FROM forms
        WHERE BASE_FORM IS NOT NULL
),

second_form_match as (
    select
        d.BATTLE_ID,
        d.TRAINER_ID,
        CASE
            WHEN d.POKEMON_ID IS NOT NULL THEN d.POKEMON_ID
            ELSE f.POKEMON_ID
        END AS POKEMON_ID,
        d.ITEM_ID,
        d.ABILITY_ID,
        d.LVL,
        d.MOVE_1,
        d.MOVE_2,
        d.MOVE_3,
        d.MOVE_4,
        d.sync_date
    FROM first_form_match d
        LEFT JOIN base_forms f ON replace(d.POKEMON_NAME, '-', '') = f.BASE_FORM
)





select * from second_form_match