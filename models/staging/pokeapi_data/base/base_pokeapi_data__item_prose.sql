with 

source as (

    select * from {{ source('pokeapi_data', 'item_prose') }}

),

renamed as (

    select
        item_id::INTEGER AS ITEM_ID,
        item_effect::VARCHAR AS ITEM_EFFECT

    from source

)

select * from renamed