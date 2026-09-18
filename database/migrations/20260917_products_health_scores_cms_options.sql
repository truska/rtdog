-- Complete the DM select options after the health-field schema migration.
INSERT INTO `cms_form_field_options` (`form_field`, `value`, `checked`, `display`, `sort`, `showonweb`, `archived`)
SELECT ff.`id`, choices.`value`, 'No', choices.`display`, choices.`sort`, 'Yes', 0
FROM `cms_form_field` ff
CROSS JOIN (
    SELECT '__NULL__' AS `value`, 'Not determined' AS `display`, 0 AS `sort`
    UNION ALL
    SELECT 'Clear', 'Clear', 10
    UNION ALL SELECT 'Affected', 'Affected', 20
    UNION ALL SELECT 'Carrier', 'Carrier', 30
) choices
WHERE ff.`form` = 2 AND ff.`name` IN ('dm-exon1', 'dm-exon2')
  AND NOT EXISTS (
      SELECT 1 FROM `cms_form_field_options` existing
      WHERE existing.`form_field` = ff.`id` AND existing.`value` = choices.`value`
  );
