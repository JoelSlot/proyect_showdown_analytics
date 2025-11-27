{% snapshot budget_snapshot_s_timestamp %}

{{
    config(
      target_schema='snapshots',
      unique_key='[battle_id, pov, turn_number]',
      strategy='timestamp',
      updated_at='sync_date',
    )
}}

select * from {{ source('showdown_data', 'match_data') }}

{% endsnapshot %}