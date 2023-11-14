include: "/views/order_items.view.lkml"

view: +order_items {

  parameter: reference_date {
    type: date
  }

  parameter: timeframe_alex {
    type: unquoted
    allowed_value: {
      value: "day_over_day"
    }
    allowed_value: {
      value: "week_over_week"
    }
  }

  parameter: type_of_comparison {
    type: unquoted
    allowed_value: {
      label: "Same Date (nov 9th to nov 9th)"
      value: "same_date"
    }
    allowed_value: {
      label: "Same Day (monday to monday)"
      value: "same_day"
    }
  }

  dimension: until_today {
    type: yesno
    sql: ${created_day_of_week_index} < EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) AND
      ${created_day_of_week_index} >= 0 ;;
  }

  dimension: is_correct_date {
    type: yesno
    sql:
    {% if timeframe_alex._parameter_value == 'day_over_day' %}
      {% if type_of_comparison._parameter_value == 'same_date' %}
        ${created_date} = DATE({% parameter reference_date %}) OR ${created_date} = DATE_ADD(DATE({% parameter reference_date %}), INTERVAL -1 YEAR)
      {% elsif type_of_comparison._parameter_value == 'same_day' %}
        ${created_date} = DATE({% parameter reference_date %}) OR ${created_date} = DATE_ADD(DATE({% parameter reference_date %}), INTERVAL -52 WEEK)
      {% endif %}
    {% elsif timeframe_alex._parameter_value == 'week_over_week' %}
      format_date('%V', ${created_date}) = format_date('%V', DATE({% parameter reference_date %}))
    {% endif %}
    ;;
  }
}
