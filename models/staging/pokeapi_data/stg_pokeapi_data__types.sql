with 

source as (

    select * from {{ source('pokeapi_data', 'types') }}

),

renamed as (

    select
        id::INTEGER AS TYPE_ID,
        identifier::VARCHAR AS TYPE_NAME

    from source

)

select * from renamed