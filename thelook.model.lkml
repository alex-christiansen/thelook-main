connection: "bigquery-sa"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: order_items {
  always_filter: {
    filters: [order_items.created_date: "1 days ago for 1 days"]
  }
  # sql_always_where: ${products.brand} IN   ({{ _user_attributes['brand'] }} ) ;;#OR ${users.state} IN ('{{ _user_attributes['state'] }}')  ;;
  sql_always_where: ${users.id} IN   ({{ _user_attributes['user_id'] }} ) ;;#OR ${users.state} IN ('{{ _user_attributes['state'] }}')  ;;
  view_name: order_items
  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
  join: inventory_items {
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
