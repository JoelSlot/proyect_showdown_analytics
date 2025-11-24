with 

source as (

    select * from {{ source('pokeapi_data', 'ability_verbose') }}

),

renamed as (

    select
        ability_id::INTEGER AS ABILITY_ID,
        flavor_text::VARCHAR AS ABILITY_EFFECT

    from source

)

select * from renamed