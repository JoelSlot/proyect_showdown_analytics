with 

source as (

    select * from {{ source('pokeapi_data', 'stats') }}

),

renamed as (

    select
        id::INTEGER AS STAT_ID,
        damage_class_id::INTEGER AS DAMAGE_CLASS_ID,
        identifier::VARCHAR AS STAT_NAME

    from source

)

select * from renamed