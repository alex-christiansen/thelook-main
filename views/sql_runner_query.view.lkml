
explore: kate_test {}
view: kate_test {
  derived_table: {
    sql: SELECT * FROM `looker-private-demo.thelook.orders`
    where created_at BETWEEN date_add({% parameter activeDate %}, INTERVAL -{% parameter lookback %} DAY)
    AND {% parameter activeDate %}


     ;;
  }

  measure: count {
    type: count
  }

  dimension: sample_column {
    type: date
  }

  parameter: activeDate {
    type: date_time
  }

  parameter: lookback {
    type: number
    default_value: "7"
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: returned_at {
    type: time
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped_at {
    type: time
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered_at {
    type: time
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: num_of_item {
    type: number
    sql: ${TABLE}.num_of_item ;;
  }

  set: detail {
    fields: [
        order_id,
  user_id,
  status,
  gender,
  created_at_time,
  returned_at_time,
  shipped_at_time,
  delivered_at_time,
  num_of_item
    ]
  }
}
