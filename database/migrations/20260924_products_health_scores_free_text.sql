-- Convert all health-score and DM fields to free text.
ALTER TABLE `products`
    MODIFY COLUMN `hipl` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Hip Left Score',
    MODIFY COLUMN `hipr` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Hip Right Score',
    MODIFY COLUMN `elbow` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Elbow Score',
    MODIFY COLUMN `dm-exon1` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Degenerative Myelopathy Status',
    MODIFY COLUMN `dm-exon2` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Degenerative Myelopathy Status';

-- Render them as text inputs in recordEditv4 and cap input at the column length.
UPDATE `cms_form_field`
SET `field` = 1,
    `datatype` = 0,
    `min` = NULL,
    `max` = 16,
    `step` = NULL
WHERE `form` = 2
  AND `name` IN ('hipl', 'hipr', 'elbow', 'dm-exon1', 'dm-exon2');

-- Remove obsolete select-list choices now that the DM fields are free text.
DELETE options
FROM `cms_form_field_options` options
INNER JOIN `cms_form_field` fields ON fields.`id` = options.`form_field`
WHERE fields.`form` = 2
  AND fields.`name` IN ('dm-exon1', 'dm-exon2');
