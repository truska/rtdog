-- Optional CMS fields may be omitted on Add and completed on Edit.
-- Preserve types, collations, comments, keys, existing defaults, and fields
-- explicitly required on Add. No existing record values are changed.

ALTER TABLE `banner`
    MODIFY COLUMN `name` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `image` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `title` varchar(512) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `subtitle` varchar(256) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `linkpage` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `sort` int(16) NOT NULL DEFAULT 99;

-- New content can be assigned to a page later. Keep a valid default layout.
ALTER TABLE `content`
    MODIFY COLUMN `page` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `layout` int(16) NOT NULL DEFAULT 3,
    MODIFY COLUMN `name` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `heading` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `subheading` varchar(120) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'use textarea',
    MODIFY COLUMN `text2` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `qtyrecords` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `date` date NULL DEFAULT NULL;

ALTER TABLE `news`
    MODIFY COLUMN `newsid` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `date` date NULL DEFAULT NULL,
    MODIFY COLUMN `text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `shorttext` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `text2` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `image` varchar(96) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'News Index grid Image',
    MODIFY COLUMN `image1` varchar(96) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'Banner Image',
    MODIFY COLUMN `imagebg` varchar(96) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'News page BG Image',
    MODIFY COLUMN `embed` varchar(512) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `metatitle` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `metadescription` varchar(512) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `metakeywords` varchar(512) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `home-head` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `home-subhead` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `home-icon` enum('youtube','mf','skai') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

ALTER TABLE `sections`
    MODIFY COLUMN `nameoverride` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `slug` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `image` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `menu1` int(8) NULL DEFAULT NULL,
    MODIFY COLUMN `menu2` int(8) NULL DEFAULT NULL,
    MODIFY COLUMN `menu3` int(8) NULL DEFAULT NULL,
    MODIFY COLUMN `page` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `manuf` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `sort` int(16) NOT NULL DEFAULT 99,
    MODIFY COLUMN `url` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `keywords` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `icon` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `image_path` int(32) NULL DEFAULT NULL;

ALTER TABLE `testimonial`
    MODIFY COLUMN `town` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `shorttext` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `url` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
    MODIFY COLUMN `section` int(16) NULL DEFAULT NULL,
    MODIFY COLUMN `date` datetime NULL DEFAULT NULL;

