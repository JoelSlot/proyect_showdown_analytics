with 

source as (

    select * from {{ source('pokeapi_data', 'move_names') }}

),

renamed as (

    select
        move_id::INTEGER AS MOVE_ID,
        name::VARCHAR AS MOVE_NAME

    from source

)

select * from renamed