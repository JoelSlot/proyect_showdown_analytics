with 

source as (

    select * from {{ source('pokeapi_data', 'ability_names') }}

),

renamed as (

    select
        ability_id::INTEGER AS ABILITY_ID,
        name::VARCHAR AS ABILITY_NAME

    from source

)

select * from renamed