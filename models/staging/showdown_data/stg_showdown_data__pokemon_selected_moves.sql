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
        d.MOVE_1,
        d.MOVE_2,
        d.MOVE_3,
        d.MOVE_4,
        d.sync_date
    FROM new_pokemon_data d
        LEFT JOIN forms f ON replace(d.POKEMON_NAME, '-', '') = replace(f.FORM_NAME, '-', '')
),

base_forms as (
        select DISTINCT
            POKEMON_ID,
            replace(FORM_NAME, concat('-', form_identifier), '') AS BASE_FORM
        FROM forms
        WHERE BASE_FORM IS NOT NULL
),

second_form_match as (
    select DISTINCT
        d.BATTLE_ID,
        d.TRAINER_ID,
        CASE
            WHEN d.POKEMON_ID IS NOT NULL THEN d.POKEMON_ID
            ELSE f.POKEMON_ID
        END AS POKEMON_ID,
        d.MOVE_1,
        d.MOVE_2,
        d.MOVE_3,
        d.MOVE_4,
        d.sync_date
    FROM first_form_match d
        LEFT JOIN base_forms f ON replace(d.POKEMON_NAME, '-', '') = f.BASE_FORM
),

sur_key_and_separated as(
    {% set move_cols = ['move_1', 'move_2', 'move_3', 'move_4'] %}

    {% for col in move_cols %}
    select
        CONCAT(p.BATTLE_ID, '-', p.TRAINER_ID, '-', p.POKEMON_ID) AS POKEMON_DATA_ID,
        m.MOVE_ID as move_ID,
        p.sync_date
    from second_form_match p
        LEFT JOIN moves m ON m.MOVE_IDENTIFIER = replace(p.{{col}}, '-', '') 
    where {{ col }} != 'nomove'
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select * from sur_key_and_separated