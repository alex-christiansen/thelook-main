explore: patient_timeline {}
view: patient_timeline {
  sql_table_name: `data-eng-on-gcp-371519.ecomm.patient_timeline` ;;

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }
  dimension: event {
    type: string
    sql: ${TABLE}.Event ;;
  }
  measure: count {
    type: count
  }
}
