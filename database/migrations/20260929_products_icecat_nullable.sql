-- Icecat is optional when adding a product.  Accommodate either legacy name
-- while retaining the existing column type.
SET @icecat_column := (
    SELECT `column_name`
    FROM `information_schema`.`columns`
    WHERE `table_schema` = DATABASE()
      AND `table_name` = 'products'
      AND `column_name` IN ('icecat', 'icecatid')
    ORDER BY FIELD(`column_name`, 'icecat', 'icecatid')
    LIMIT 1
);

SET @icecat_type := (
    SELECT `column_type`
    FROM `information_schema`.`columns`
    WHERE `table_schema` = DATABASE()
      AND `table_name` = 'products'
      AND `column_name` = @icecat_column
);

SET @icecat_sql := IF(
    @icecat_column IS NULL,
    'SELECT 1',
    CONCAT('ALTER TABLE `products` MODIFY COLUMN `', @icecat_column, '` ', @icecat_type, ' NULL DEFAULT NULL')
);
PREPARE icecat_statement FROM @icecat_sql;
EXECUTE icecat_statement;
DEALLOCATE PREPARE icecat_statement;
