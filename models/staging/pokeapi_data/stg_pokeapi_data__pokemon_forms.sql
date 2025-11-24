with 

source as (

    select * from {{ ref('base_pokeapi_data__pokemon_forms') }}

)


select * from source