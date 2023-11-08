view: products {
  sql_table_name: looker-private-demo.ecomm.products ;;
  view_label: "Products"
  ### DIMENSIONS ###

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: category {
    label: "Category"
    sql: TRIM(${TABLE}.category) ;;
    drill_fields: [department, brand, item_name]
  }

  dimension: item_name {
    label: "Item Name"
    sql: TRIM(${TABLE}.name) ;;
    drill_fields: [id]
  }

  parameter: big_search_filter {
    suggestable: yes
    suggest_dimension: brand
    type: string
    # suggest_explore: order_items
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    html:
         {% assign foo = big_search_filter._parameter_value | remove: "'" %}
          {% if value == foo  %}
          <b><p style="color: black; background-color: #FBBC04; font-size:100%">{{ value }}</b></p>
          {% else %}
          {{ value }}
          {% endif %};;
  }

  dimension: retail_price {
    label: "Retail Price"
    type: number
    sql: ${TABLE}.retail_price ;;
    action: {
      label: "Update Price"
      url: "https://us-central1-sandbox-trials.cloudfunctions.net/ecomm_inventory_writeback"
      param: {
        name: "Price"
        value: "24"
      }
      form_param: {
        name: "Discount"
        label: "Discount Tier"
        type: select
        option: {
          name: "5% off"
        }
        option: {
          name: "10% off"
        }
        option: {
          name: "20% off"
        }
        option: {
          name: "30% off"
        }
        option: {
          name: "40% off"
        }
        option: {
          name: "50% off"
        }
        default: "20% off"
      }
      param: {
        name: "retail_price"
        value: "{{ retail_price._value }}"
      }
      param: {
        name: "inventory_item_id"
        value: "{{ inventory_items.id._value }}"
      }
      param: {
        name: "product_id"
        value: "{{ id._value }}"
      }
      param: {
        name: "security_key"
        value: "googledemo"
      }
    }
  }

  dimension: department {
    label: "Department"
    sql: TRIM(${TABLE}.department) ;;
    html:
     {% assign foo = big_search_filter._parameter_value | remove: "'" %}
          {% if brand._value == foo  %}
          <b><p style="color: black; background-color: #FBBC04; font-size:100%">{{ value }}</b></p>
          {% else %}
          {{ value }}
          {% endif %};;
  }

  dimension: sku {
    label: "SKU"
    sql: ${TABLE}.sku ;;
  }

  dimension: distribution_center_id {
    label: "Distribution Center ID"
    type: number
    sql: CAST(${TABLE}.distribution_center_id AS INT64) ;;
  }

  ## MEASURES ##

  measure: count {
    label: "Count"
    type: count
    drill_fields: [detail*]
  }

  measure: brand_count {
    label: "Brand Count"
    type: count_distinct
    sql: ${brand} ;;
    drill_fields: [brand, detail2*, -brand_count] # show the brand, a bunch of counts (see the set below), don't show the brand count, because it will always be 1
  }

  measure: category_count {
    label: "Category Count"
    alias: [category.count]
    type: count_distinct
    sql: ${category} ;;
    drill_fields: [category, detail2*, -category_count] # don't show because it will always be 1
  }

  measure: department_count {
    label: "Department Count"
    alias: [department.count]
    type: count_distinct
    sql: ${department} ;;
    drill_fields: [department, detail2*, -department_count] # don't show because it will always be 1
  }

  measure: prefered_categories {
    hidden: yes
    label: "Prefered Categories"
    type: list
    list_field: category
    #order_by_field: order_items.count

  }

  measure: prefered_brands {
    hidden: yes
    label: "Prefered Brand"
    type: list
    list_field: brand
    #order_by_field: count
  }

  set: detail {
    fields: [id, item_name, brand, category, department, retail_price, customers.count, orders.count, order_items.count, inventory_items.count]
  }

  set: detail2 {
    fields: [category_count, brand_count, department_count, count, customers.count, orders.count, order_items.count, inventory_items.count, products.count]
  }
}
