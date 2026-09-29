-- Permit a new product to be created before optional catalogue, pedigree, and
-- commercial details have been entered.  Preserve each existing column type
-- and exclude the auto-increment primary key.
SET @products_optional_sql := (
    SELECT CONCAT(
        'ALTER TABLE `products` ',
        GROUP_CONCAT(
            CONCAT('MODIFY COLUMN `', `column_name`, '` ', `column_type`, ' NULL DEFAULT NULL')
            ORDER BY `ordinal_position`
            SEPARATOR ', '
        )
    )
    FROM `information_schema`.`columns`
    WHERE `table_schema` = DATABASE()
      AND `table_name` = 'products'
      AND `is_nullable` = 'NO'
      AND `column_default` IS NULL
      AND `extra` NOT LIKE '%auto_increment%'
);

SET @products_optional_sql := COALESCE(@products_optional_sql, 'SELECT 1');
PREPARE products_optional_statement FROM @products_optional_sql;
EXECUTE products_optional_statement;
DEALLOCATE PREPARE products_optional_statement;
