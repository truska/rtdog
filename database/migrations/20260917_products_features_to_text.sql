-- Copy legacy product feature fields into the product text field as HTML.
-- Original feature1, feature2 and feature3 values are intentionally retained.
-- This only updates empty text fields, making it safe to run once without
-- replacing product descriptions added later.
UPDATE `products`
SET `text` = CONCAT(
    '<ul>',
    CONCAT_WS('',
        IF(NULLIF(TRIM(`feature1`), '') IS NULL, NULL,
            CONCAT('<li>', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(`feature1`), '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#039;'), '</li>')),
        IF(NULLIF(TRIM(`feature2`), '') IS NULL, NULL,
            CONCAT('<li>', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(`feature2`), '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#039;'), '</li>')),
        IF(NULLIF(TRIM(`feature3`), '') IS NULL, NULL,
            CONCAT('<li>', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(`feature3`), '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#039;'), '</li>'))
    ),
    '</ul>'
)
WHERE (TRIM(COALESCE(`feature1`, '')) <> ''
       OR TRIM(COALESCE(`feature2`, '')) <> ''
       OR TRIM(COALESCE(`feature3`, '')) <> '')
  AND TRIM(COALESCE(`text`, '')) = '';
