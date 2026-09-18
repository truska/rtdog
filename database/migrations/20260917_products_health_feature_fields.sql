-- Label the imported health-score columns and add the second DM score.
-- Values in feature1 through feature3 are retained unchanged.
ALTER TABLE `products`
    MODIFY COLUMN `feature1` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Hip Score',
    MODIFY COLUMN `feature2` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Elbow Score',
    MODIFY COLUMN `feature3` VARCHAR(64) NULL DEFAULT NULL COMMENT 'DM Score EXON1',
    ADD COLUMN `feature4` VARCHAR(64) NULL DEFAULT NULL COMMENT 'DM Score EXON2' AFTER `feature3`;
