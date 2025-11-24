with 

source as (

    select * from {{ source('pokeapi_data', 'abilities') }}

),

renamed as (

    select
        id::INTEGER AS ABILITY_ID,
        REPLACE(identifier, '-', '')::Varchar AS ABILITY_IDENTIFIER

    from source

)

select * from renamed