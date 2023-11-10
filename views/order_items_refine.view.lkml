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

  parameter: timeframe {
    view_label: "Period over Period"
    type: unquoted
    allowed_value: {
      label: "Week to Date"
      value: "Week"
    }
    allowed_value: {
      label: "Month to Date"
      value: "Month"
    }
    allowed_value: {
      label: "Quarter to Date"
      value: "Quarter"
    }
    allowed_value: {
      label: "Year to Date"
      value: "Year"
    }
    default_value: "Quarter"
  }

  # To get start date we need to get either first day of the year, month or quarter
  dimension: first_date_in_period {
    view_label: "Period over Period"
    type: date
    hidden: no
    sql: DATE_TRUNC(CURRENT_DATE(), {% parameter timeframe %});;
  }

  #Now get the total number of days in the period
  dimension: days_in_period {
    view_label: "Period over Period"
    type: number
    hidden: no
    sql: DATE_DIFF(CURRENT_DATE(),${first_date_in_period}, DAY) ;;
  }

  #Now get the first date in the prior period
  dimension: first_date_in_prior_period {
    view_label: "Period over Period"
    type: date
    hidden: no
    sql: DATE_TRUNC(DATE_ADD(CURRENT_DATE(), INTERVAL -1 {% parameter timeframe %}),{% parameter timeframe %});;
  }

  #Now get the last date in the prior period
  dimension: last_date_in_prior_period {
    view_label: "Period over Period"
    type: date
    hidden: no
    sql: DATE_ADD(${first_date_in_prior_period}, INTERVAL ${days_in_period} DAY) ;;
  }

  # Now figure out which period each date belongs in (update with your own date dimension that you want to leverage)
  dimension: period_selected {
    view_label: "Period over Period"
    type: string
    sql:
        CASE
          WHEN ${created_date} >=  ${first_date_in_period}
          THEN 'This {% parameter timeframe %} to Date'
          WHEN ${created_date} >= ${first_date_in_prior_period}
          AND ${created_date} <= ${last_date_in_prior_period}
          THEN 'Prior {% parameter timeframe %} to Date'
          ELSE NULL
          END ;;
  }
}
