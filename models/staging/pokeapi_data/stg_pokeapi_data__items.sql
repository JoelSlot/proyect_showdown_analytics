with 

names as (

    select * from {{ ref('base_pokeapi_data__item_names') }}

),
items as (
    select * from {{ref('base_pokeapi_data__items')}}
),
prose as (
    select * from {{ref('base_pokeapi_data__item_prose')}}
),
renamed as (

    select
        items.ITEM_ID,
        items.ITEM_IDENTIFIER,
        names.ITEM_NAME,
        prose.ITEM_EFFECT

    from items
        LEFT JOIN names ON items.item_id = names.item_id
        LEFT JOIN prose ON items.item_id = prose.item_id

)

select * from renamed