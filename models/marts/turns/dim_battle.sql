{{
    config(
        materialized='incremental'
    )
}}


with

battle as(
    select * from {{ref('stg_showdown_data__battles')}}

    {% if is_incremental() %}

    where sync_date > (select max(sync_date) from {{ this }})

    {% endif %}
),
trainers as(
    select * from {{ref('stg_showdown_data__trainers')}}
),
new_model as (
    SELECT
        b.BATTLE_ID,
        b.FORMAT_ID,
        b.IS_RATED,
        b.ELO,
        tw.TRAINER_NAME AS WINNER,
        tl.TRAINER_NAME AS LOSER,
        b.TOTAL_TURNS,
        b.BATTLE_DATE,
        b.sync_date
    from battle b
        LEFT JOIN trainers tw ON b.WINNER_ID = tw.TRAINER_ID
        LEFT JOIN trainers tl ON b.LOSER_ID = tl.TRAINER_ID
)

select * from new_model