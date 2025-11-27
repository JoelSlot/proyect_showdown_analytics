{{
    config(
        materialized='incremental'
    )
}}


with

pokemon_data as (
    select * from {{ref('stg_showdown_data__pokemon_data')}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

pokemon_selected_moves as (
    select * from {{ref ('stg_showdown_data__pokemon_selected_moves')}}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

new_model as (
    select DISTINCT
        P.pokemon_data_id,
        P.battle_id,
        P.trainer_id,
        P.pokemon_id,
        P.item_id,
        P.ability_id,
        P.lvl,
        {% set move_index = ['1', '2', '3', '4'] %}
        {% for index in move_index %}
        m{{index}}.move_id as move_{{index}},
        {% endfor %}
        P.sync_date
    from pokemon_data P
        {% for index in move_index %}
        LEFT JOIN pokemon_selected_moves m{{index}} ON m{{index}}.pokemon_data_id = P.pokemon_data_id AND m{{index}}.MOVESET_ORDER = {{index}}
        {% endfor %}
)

select DISTINCT * from new_model