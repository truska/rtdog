-- Replace the legacy generic feature fields with dedicated dog-health fields.
-- Preserve the imported feature values under clear legacy names. They were
-- also copied to products.text by the preceding migration.
ALTER TABLE `products`
    DROP COLUMN `feature1start`,
    DROP COLUMN `feature1end`,
    DROP COLUMN `feature2start`,
    DROP COLUMN `feature2end`,
    DROP COLUMN `feature3start`,
    DROP COLUMN `feature3end`,
    CHANGE COLUMN `feature1` `legacy_feature1` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Legacy imported feature 1 (preserved)',
    CHANGE COLUMN `feature2` `legacy_feature2` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Legacy imported feature 2 (preserved)',
    CHANGE COLUMN `feature3` `legacy_feature3` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Legacy imported feature 3 (preserved)',
    CHANGE COLUMN `feature4` `legacy_feature4` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Legacy imported feature 4 (preserved)',
    ADD COLUMN `hipl` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT 'Hip Left Score' AFTER `legacy_feature4`,
    ADD COLUMN `hipr` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT 'Hip Right Score' AFTER `hipl`,
    ADD COLUMN `elbow` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT 'Elbow Score' AFTER `hipr`,
    ADD COLUMN `dm-exon1` ENUM('Clear', 'Affected', 'Carrier') NULL DEFAULT NULL COMMENT 'Degenerative Myelopathy Status' AFTER `elbow`,
    ADD COLUMN `dm-exon2` ENUM('Clear', 'Affected', 'Carrier') NULL DEFAULT NULL COMMENT 'Degenerative Myelopathy Status' AFTER `dm-exon1`;

-- Form 2 uses the product-column comments as the CMS labels.
INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 33, 9, `column_comment`, 'hipl', 'small', '', 'No', 'No', 0, 0, 5, 1, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'hipl'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'hipl');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 34, 9, `column_comment`, 'hipr', 'small', '', 'No', 'No', 0, 0, 5, 1, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'hipr'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'hipr');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 35, 9, `column_comment`, 'elbow', 'small', '', 'No', 'No', 0, 0, 3, 1, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'elbow'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'elbow');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 36, 16, `column_comment`, 'dm-exon1', 'small', '', 'No', 'No', 0, NULL, NULL, NULL, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'dm-exon1'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'dm-exon1');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 37, 16, `column_comment`, 'dm-exon2', 'small', '', 'No', 'No', 0, NULL, NULL, NULL, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'dm-exon2'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'dm-exon2');

-- Select options for both Degenerative Myelopathy fields.
INSERT INTO `cms_form_field_options` (`form_field`, `value`, `checked`, `display`, `sort`, `showonweb`, `archived`)
SELECT ff.`id`, choices.`value`, 'No', choices.`value`, choices.`sort`, 'Yes', 0
FROM `cms_form_field` ff
CROSS JOIN (
    SELECT 'Clear' AS `value`, 10 AS `sort`
    UNION ALL SELECT 'Affected', 20
    UNION ALL SELECT 'Carrier', 30
) choices
WHERE ff.`form` = 2 AND ff.`name` IN ('dm-exon1', 'dm-exon2')
  AND NOT EXISTS (
      SELECT 1 FROM `cms_form_field_options` existing
      WHERE existing.`form_field` = ff.`id` AND existing.`value` = choices.`value`
  );
