explore: zip_codes {}

view: zip_codes {
  sql_table_name: `data-eng-on-gcp-371519.zip.zip_codes` ;;

  dimension: area_code {
    type: string
    sql: ${TABLE}.`AREA CODE` ;;
  }
  dimension: area_name {
    type: string
    sql: ${TABLE}.`AREA NAME` ;;
  }
  dimension: delivery_zipcode {
    type: number
    sql: ${TABLE}.`DELIVERY ZIPCODE` ;;
  }
  dimension: district_name {
    type: string
    sql: ${TABLE}.`DISTRICT NAME` ;;
  }
  dimension: district_no {
    type: number
    sql: ${TABLE}.`DISTRICT NO` ;;
  }
  dimension: locale_name {
    type: string
    sql: ${TABLE}.`LOCALE NAME` ;;
  }
  dimension: physical_city {
    type: string
    sql: ${TABLE}.`PHYSICAL CITY` ;;
  }
  dimension: physical_delv_addr {
    type: string
    sql: ${TABLE}.`PHYSICAL DELV ADDR` ;;
  }
  dimension: physical_state {
    type: string
    sql: ${TABLE}.`PHYSICAL STATE` ;;
  }
  dimension: physical_zip {
    type: number
    sql: ${TABLE}.`PHYSICAL ZIP` ;;
  }
  dimension: physical_zip_4 {
    type: number
    sql: ${TABLE}.`PHYSICAL ZIP 4` ;;
  }
  dimension: physical_zip_string {
    type: string
    sql: ${TABLE}.physical_zip_string ;;
  }
  measure: count {
    type: count
    drill_fields: [locale_name, district_name, area_name]
  }
}
