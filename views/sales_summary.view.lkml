
view: sales_summary {
  derived_table: {
    sql: with daily_sales as (
        select date(created_at) as created_date,
               sum(sale_price) as sale_price
        from looker-private-demo.ecomm.order_items
        group by 1

      )

      select created_date
             ,round(sum(sale_price),2) as total_sale_price
             ,lag(sum(sale_price)) over (order by created_date) as yesterday_sale
             ,lag(sum(sale_price),365) over (order by created_date) as last_year_sale
             ,lag(sum(sale_price),365) over (order by created_date) as last_year_sale_same_date
      from daily_sales
      group by 1
      order by 1 desc ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: created_date {
    type: date
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: total_sale_price {
    type: number
    sql: ${TABLE}.total_sale_price ;;
  }

  dimension: yesterday_sale {
    type: number
    sql: ${TABLE}.yesterday_sale ;;
  }

  dimension: last_year_sale {
    type: number
    sql: ${TABLE}.last_year_sale ;;
  }

  dimension: last_year_sale_same_date {
    type: number
    sql: ${TABLE}.last_year_sale_same_date ;;
  }

  set: detail {
    fields: [
        created_date,
  total_sale_price,
  yesterday_sale,
  last_year_sale,
  last_year_sale_same_date
    ]
  }
}
