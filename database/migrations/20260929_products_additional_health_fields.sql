-- Add further free-text health test results for dogs.
ALTER TABLE `products`
    ADD COLUMN `vmd1` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Von Willebrand Type 1 (VMD1)' AFTER `dm-exon2`,
    ADD COLUMN `coi` VARCHAR(16) NULL DEFAULT NULL COMMENT 'COI (KC)' AFTER `vmd1`,
    ADD COLUMN `h` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Histiocytic Sarcoma (HS) Test' AFTER `coi`;

-- Add the fields to the dog CMS form as unrestricted text inputs.
INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 38, 1, `column_comment`, 'vmd1', 'small', '', 'No', 'No', 0, NULL, 16, NULL, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'vmd1'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'vmd1');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 39, 1, `column_comment`, 'coi', 'small', '', 'No', 'No', 0, NULL, 16, NULL, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'coi'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'coi');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `min`, `max`, `step`, `comment`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
SELECT `column_comment`, 2, 7, 1, 40, 1, `column_comment`, 'h', 'small', '', 'No', 'No', 0, NULL, 32, NULL, '', '', 0, 'No', 'No', 'No', 'Yes', 'Yes', 'Yes'
FROM `information_schema`.`columns`
WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'h'
  AND NOT EXISTS (SELECT 1 FROM `cms_form_field` WHERE `form` = 2 AND `name` = 'h');
