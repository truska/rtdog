-- Section is optional when adding a product.
ALTER TABLE `products`
    MODIFY COLUMN `section` INT(16) NULL DEFAULT NULL;
