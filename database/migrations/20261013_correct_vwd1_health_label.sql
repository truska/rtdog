-- Correct display labels while retaining the existing field name and data.
UPDATE `cms_form_field`
SET `title` = REPLACE(REPLACE(`title`, 'VMD1', 'VWD1'), 'WMD1', 'VWD1'),
    `label` = REPLACE(REPLACE(`label`, 'VMD1', 'VWD1'), 'WMD1', 'VWD1')
WHERE `name` = 'vmd1';

ALTER TABLE `products`
    MODIFY COLUMN `vmd1` VARCHAR(16) NULL DEFAULT NULL
    COMMENT 'Von Willebrand Type 1 (VWD1)';
