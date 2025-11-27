{% snapshot pokemon_data_snapshot_s_timestamp %}

{{
    config(
      target_schema='snapshots',
      unique_key='[battle_id, trainer, name]',
      strategy='timestamp',
      updated_at='sync_date',
    )
}}

select * from {{ source('showdown_data', 'pokemon_data') }}

{% endsnapshot %}