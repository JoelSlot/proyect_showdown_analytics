with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_type_efficacy') }}

),

renamed as (

    select
        damage_type_id::INTEGER AS DAMAGE_TYPE_ID,
        target_type_id::INTEGER AS TARGET_TYPE_ID,
        damage_factor::INTEGER AS DAMAGE_FACTOR

    from source

)

select * from renamed