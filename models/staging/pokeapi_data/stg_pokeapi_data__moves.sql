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

    UNION all
    SELECT 
        -1 AS MOVE_ID,
        'nomove' AS MOVE_IDENTIFIER,
        'No move' AS MOVE_NAME,
        20 AS TYPE_ID, --unknown type
        null AS POWER,
        null AS PP,
        null AS ACCURACY,
        null AS PRIORITY,
        3 AS DAMAGE_CLASS_ID

)

select * from renamed