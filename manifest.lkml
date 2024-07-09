project_name: "google-demo-project"


constant: currency_html {
  value: "
  {% if currency_parameter._parameter_value == 'EURO' %}
  {% assign currency_symbol = '€' %}
  {% elsif currency_parameter._parameter_value == 'USD' %}
  {% assign currency_symbol = '$' %}
  {% else %}
  {% assign currency_symbol = '₪' %}
  {% endif %}

  {% if value > 0 %}
  {% assign currency_value = currency_symbol | append: rendered_value %}
  {% else %}
  {% assign abs_value = value | replace: '-', '' %}
  {% assign currency_value = '-' | append: currency_symbol | append: abs_value %}
  {% endif %}

  {% if currency_parameter._parameter_value == 'EURO' or currency_parameter._parameter_value == 'Shekel' %}
  {{ currency_value | replace_first: '.', ',' | replace_first: ',', '.' }}
  {% else %}
  {{ currency_value }}
  {% endif %}
  "
}
