{{
    config(
        materialized='incremental'
    )
}}

with match_data as (

    select * from {{ ref('base_showdown_data__match_data') }}
  
),

forms as (
    select * from {{ ref('base_pokeapi_data__pokemon_forms') }}
),

new_match_data as (

    select * from match_data

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

first_form_match as (

    select
        d.BATTLE_ID,
        md5(d.POV) AS POV_TRAINER_ID,
        d.TURN_NUMBER,
        f.POKEMON_ID,
        d.ACTIVE_POKEMON_NAME,
        d.ACTIVE_POKEMON_HP AS POKEMON_HP,
        d.ACTIVE_POKEMON_STATUS AS POKEMON_STATUS,
        d.ACTIVE_POKEMON_EFFECT AS POKEMON_EFFECT,
        d.POV_LAST_MOVE as LAST_MOVE,
        d.sync_date
    from new_match_data d
        LEFT JOIN forms f ON replace(d.ACTIVE_POKEMON_NAME, '-', '') = replace(f.FORM_NAME, '-', '')
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
        d.POV_TRAINER_ID,
        d.TURN_NUMBER,
        CASE
            WHEN d.POKEMON_ID IS NOT NULL THEN d.POKEMON_ID
            ELSE f.POKEMON_ID
        END AS POKEMON_ID,
        d.POKEMON_HP,
        d.POKEMON_STATUS,
        d.POKEMON_EFFECT,
        d.LAST_MOVE,
        d.sync_date
    FROM first_form_match d
        LEFT JOIN base_forms f ON replace(d.ACTIVE_POKEMON_NAME, '-', '') = f.BASE_FORM
)

select * from second_form_match