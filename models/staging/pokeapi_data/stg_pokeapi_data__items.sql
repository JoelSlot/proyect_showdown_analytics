with 

source as (

    select * from {{ source('pokeapi_data', 'items') }}

),

renamed as (

    select
        id::INTEGER AS ITEM_ID,
        replace(identifier, '-', ' ')::VARCHAR AS ITEM_NAME

    from source

)

select * from renamed