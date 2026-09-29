-- A short display name is optional when adding a product.
ALTER TABLE `products`
    MODIFY COLUMN `nameshort` VARCHAR(48) NULL DEFAULT NULL;
