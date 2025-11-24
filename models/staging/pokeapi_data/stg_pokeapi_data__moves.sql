with 

names as (

    select * from {{ ref('base_pokeapi_data__move_names') }}

),
moves as (
    select * from {{ ref('base_pokeapi_data__moves') }}
),

renamed as (

    select
        m.MOVE_ID,
        m.MOVE_IDENTIFIER,
        n.MOVE_NAME,
        m.TYPE_ID,
        m.POWER,
        m.PP,
        m.ACCURACY,
        m.PRIORITY,
        m.DAMAGE_CLASS_ID
    from moves m
    LEFT JOIN names n ON m.MOVE_ID = n.MOVE_ID

)

select * from renamed