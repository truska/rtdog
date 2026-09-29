-- Rename the initially introduced HS column without losing any entered value.
SET @rename_hs_sql := IF(
    EXISTS (
        SELECT 1 FROM `information_schema`.`columns`
        WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'h'
    )
    AND NOT EXISTS (
        SELECT 1 FROM `information_schema`.`columns`
        WHERE `table_schema` = DATABASE() AND `table_name` = 'products' AND `column_name` = 'hs'
    ),
    'ALTER TABLE `products` CHANGE COLUMN `h` `hs` VARCHAR(32) NULL DEFAULT NULL COMMENT ''Histiocytic Sarcoma (HS) Test''',
    'SELECT 1'
);
PREPARE rename_hs_statement FROM @rename_hs_sql;
EXECUTE rename_hs_statement;
DEALLOCATE PREPARE rename_hs_statement;

UPDATE `cms_form_field`
SET `name` = 'hs'
WHERE `form` = 2 AND `name` = 'h';
