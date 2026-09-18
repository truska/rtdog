-- Replace the legacy product visibility flag with the public listing flag.
ALTER TABLE `products`
    CHANGE COLUMN `alwaysinstock` `showonall` ENUM('Yes', 'No') NOT NULL DEFAULT 'No';

-- Dogs and bitches are listed publicly only when they are opted into the menu.
UPDATE `products`
SET `showonall` = CASE WHEN `showonmenu` = 'Yes' THEN 'Yes' ELSE 'No' END
WHERE `section` IN (1, 2);
