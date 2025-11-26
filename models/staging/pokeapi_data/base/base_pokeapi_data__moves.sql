with 

source as (

    select * from {{ source('pokeapi_data', 'moves') }}

),

renamed as (

    select
        id::INTEGER AS MOVE_ID,
        replace(identifier, '-', '')::VARCHAR AS MOVE_IDENTIFIER,
        type_id::INTEGER AS TYPE_ID,
        power::INTEGER AS POWER,
        pp::INTEGER AS PP,
        accuracy::INTEGER AS ACCURACY,
        priority::INTEGER AS PRIORITY,
        damage_class_id::INTEGER AS DAMAGE_CLASS_ID
    from source
    WHERE generation_id < 5 --removes new gen moves
            AND MOVE_ID < 1000 --removes pokemon DX moves

)

select * from renamed