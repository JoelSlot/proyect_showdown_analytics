with 

source as (

    select * from {{ source('pokeapi_data', 'item_names') }}

),

renamed as (

    select
        item_id::INTEGER AS ITEM_ID,
        name::VARCHAR AS ITEM_NAME

    from source

)

select * from renamed