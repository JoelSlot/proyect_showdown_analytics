with 

source as (

    select * from {{ source('pokeapi_data', 'move_damage_classes') }}

),

renamed as (

    select
        id::INTEGER AS DAMAGE_CLASS_ID,
        identifier::VARCHAR AS DAMAGE_CLASS_NAME

    from source

)

select * from renamed