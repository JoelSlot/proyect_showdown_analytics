with 

source as (

    select * from {{ source('pokeapi_data', 'pokemon_stats') }}

),

renamed as (

    select
        pokemon_id::INTEGER AS POKEMON_ID,
        stat_id::INTEGER AS STAT_ID,
        base_stat::INTEGER AS BASE_STAT

    from source

)

select * from renamed