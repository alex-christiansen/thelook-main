connection: "bigquery-adc"
label: " eCommerce - Demo"
# include: "/queries/queries*.view" # includes all queries refinements
include: "/views/**/*.view" # include all the views

############ Model Configuration #############

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

persist_with: ecommerce_etl
############ Base Explores #############

explore: order_items {
  label: "(1) Orders, Items and Users"
  # view_name: order_items

  join: order_facts {
    type: left_outer
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
  }

  join: inventory_items {
    view_label: "Inventory Items"
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: user_order_facts {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }

  join: products {
    view_label: "Products"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: repeat_purchase_facts {
    view_label: "Repeat Purchase Facts"
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: distribution_centers {
    view_label: "Distribution Center"
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }
}
