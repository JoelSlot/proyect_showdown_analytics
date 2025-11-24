{{
    config(
        materialized='incremental'
    )
}}


with 

source as (

    select * from {{ source('showdown_data', 'match_data') }}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}

),

renamed as (

    select
        battle_id::VARCHAR AS BATTLE_ID,
        format::VARCHAR AS FORMAT,
        elo::VARCHAR AS ELO,
        pov::VARCHAR AS POV,
        opponent::VARCHAR AS OPPONENT,
        date::VARCHAR AS BATTLE_DATE,
        result::VARCHAR AS RESULT,
        total_turns::INTEGER AS TOTAL_TURNS,
        turn_number::INTEGER AS TURN_NUMBER,
        active_pokemon_name::VARCHAR AS ACTIVE_POKEMON_NAME,
        active_pokemon_base_species::VARCHAR AS ACTIVE_POKEMON_BASE_SPECIES,
        active_pokemon_hp::FLOAT AS ACTIVE_POKEMON_HP,
        active_pokemon_status::VARCHAR AS ACTIVE_POKEMON_STATUS,
        active_pokemon_effect::VARCHAR AS ACTIVE_POKEMON_EFFECT,
        move_1_pp::INTEGER AS MOVE_1_PP,
        move_2_pp::INTEGER AS MOVE_2_PP,
        move_3_pp::INTEGER AS MOVE_3_PP,
        move_4_pp::INTEGER AS MOVE_4_PP,
        opponent_pokemon_name::VARCHAR AS OPPONENT_POKEMON_NAME,
        opponent_pokemon_species::VARCHAR AS OPPONENT_POKEMON_BASE_SPECIES,
        opponent_pokemon_hp::FLOAT AS OPPONENT_POKEMON_HP,
        opponent_pokemon_status::VARCHAR AS OPPONENT_POKEMON_STATUS,
        opponent_pokemon_effect::VARCHAR AS OPPONENT_POKEMON_EFFECT,
        pov_last_move::VARCHAR AS POV_LAST_MOVE,
        opponent_last_move::VARCHAR AS OPPONENT_LAST_MOVE,
        next_action::VARCHAR AS NEXT_ACTION,
        sync_date

    from source

)

select * from renamed