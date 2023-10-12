view: order_items {
  sql_table_name: `looker-private-demo.ecomm.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status_five {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  parameter: currency_parameter {
    label: "Currency"
    type: unquoted
    default_value: "EURO"
    allowed_value: {
      label: "Euro"
      value: "EURO"
    }
    allowed_value: {
      label: "USD"
      value: "USD"
    }
    allowed_value: {
      label: "Shekel"
      value: "Shekel"
    }
  }

  dimension: price_euro {
    hidden: yes
    type: number
    sql: ${sale_price} ;;
    value_format_name: decimal_2
  }

  dimension: price_usd {
    hidden: yes
    type: number
    sql: 1.0 * ${price_euro} * 75/100 ;;
    value_format_name: decimal_2
  }

  dimension: price_shekel {
    hidden: yes
    type: number
    sql: 1.0 * ${price_euro} * 25/100 ;;
    value_format_name: decimal_2
  }

  dimension: price_currency {
    label: "Price"
    type: number
    sql:
    {% if currency_parameter._parameter_value == 'EURO' %}
      ${price_euro}
    {% elsif currency_parameter._parameter_value == 'USD' %}
      ${price_usd}
    {% else %}
      ${price_shekel}
    {% endif %} ;;
    value_format_name: decimal_2
    html: @{currency_html}{{rendered_value}} ;;
  }
  # measure: total_sale_price_usd {
  #   type: sum
  #   sql: ${sale_price} ;;
  #   value_format: "@{usd}"
  # }

  # measure: total_sale_price_shekel {
  #   type: sum
  #   sql: ${sale_price} ;;
  #   value_format: "@{shekel}}"
  # }

  measure: total_price_currency {
    label: "Total Price"
    type: sum
    sql: ${price_currency} ;;
    value_format_name: decimal_2
    html: @{currency_html} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name
  ]
  }

}
