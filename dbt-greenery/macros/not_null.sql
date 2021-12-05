{% macro not_null(field_name) %}

    where {{ field_name }} is not null

{% endmacro %}