{{
    config(
        materialized='incremental'
    )
}}

with new_pokemon_data as (

    select * from {{ ref('stg_showdown_data__pokemon_data') }}
    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),
new_battle_data as(
    select * from {{ref('stg_showdown_data__battles')}}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),

ordered_pokemon as (
    SELECT
        *,
        row_number() OVER (PARTITION BY BATTLE_ID, TRAINER_ID ORDER BY POKEMON_ID) AS team_order
    from new_pokemon_data
),

new_model as (
    {% set trainer_cols = ['WINNER_ID', 'LOSER_ID'] %}
    {% set team_holes = ['1', '2', '3', '4', '5', '6']%}
    {% for trainer_id in trainer_cols %}
    {% set outer_loop = loop%}
    select
        CONCAT(d.BATTLE_ID,'-', d.{{trainer_id}}) AS TEAM_ID,
        {%for hole in team_holes%}
        CASE
            WHEN p{{hole}}.POKEMON_ID IS NOT NULL THEN CONCAT(d.BATTLE_ID,'-', d.{{trainer_id}},'-', p{{hole}}.POKEMON_ID)
        ELSE null
        END AS POKEMON_SET_{{hole}}_ID,
        {% endfor %}
        d.sync_date
    from new_battle_data d
        {% for hole in team_holes%}
        LEFT JOIN ordered_pokemon p{{hole}} ON d.BATTLE_ID = p{{hole}}.BATTLE_ID AND d.{{trainer_id}} = p{{hole}}.TRAINER_ID
            AND {{hole}} = p{{hole}}.team_order
        {% endfor %}
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select * from new_model



