-- Litters: make the legacy table compatible with the current CMS and gallery.
-- Run once against the site database.

ALTER TABLE `litters`
    MODIFY `dob` DATE NULL,
    MODIFY `heading` VARCHAR(256) NOT NULL DEFAULT '',
    MODIFY `text` LONGTEXT NULL,
    MODIFY `sire` INT(16) NULL,
    MODIFY `dam` INT(16) NULL,
    MODIFY `showonweb` ENUM('Yes','No') NOT NULL DEFAULT 'Yes',
    ADD COLUMN `reserved` ENUM('Yes','No') NOT NULL DEFAULT 'No' AFTER `text`,
    ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `showonweb`,
    ADD COLUMN `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `created`,
    ADD COLUMN `archived` TINYINT(1) NOT NULL DEFAULT 0 AFTER `modified`,
    ADD KEY `litters_public` (`showonweb`, `archived`, `dob`),
    ADD KEY `litters_sire` (`sire`),
    ADD KEY `litters_dam` (`dam`);

INSERT INTO `cms_table` (`id`, `title`, `name`, `showonweb`)
VALUES (14, 'Litters', 'litters', 'Yes');

INSERT INTO `cms_form`
    (`id`, `title`, `name`, `table`, `col1`, `col1type`, `col2`, `col2type`, `col3`, `col3table`, `col3type`, `col4`, `col4table`, `col4type`, `col5`, `col5type`, `col6`, `col6type`, `sort1`, `sort1order`, `text`, `viewnotes`, `gallery`, `gallery_table`, `afterAdd`, `afterEdit`, `issortable`, `sortcol`, `where1`, `maxgalleryimage`, `showcopy`, `showdelete`, `showsearch`, `showarchived`, `showonweb`)
VALUES
    (18, 'Litters', 'litters', 14, 'heading', 'Search', 'dob', 'Search', 'sire', 'products', 'Search', 'dam', 'products', 'Search', 'reserved', 'Select', 'showonweb', 'Select', 'dob', 'DESC', '', '', 'Yes', 'gallery', 'recordEditv4.php?frm=[frm]&id=[id]', 'recordEditv4.php?frm=[frm]&id=[id]', 'No', '', '', 24, 'Yes', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `sourcesqlWHERE`, `file_ext`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Litter Heading', 18, 14, 1, 10, 1, 'Litter Heading', 'heading', 'medium', '', 'Yes', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Date of Birth', 18, 14, 1, 20, 6, 'Date of Birth', 'dob', 'small', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Sire', 18, 14, 1, 30, 18, 'Sire', 'sire', 'medium', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Dam', 18, 14, 1, 40, 18, 'Dam', 'dam', 'medium', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Litter Details', 18, 14, 1, 50, 19, 'Litter Details', 'text', '', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Reserved', 18, 14, 1, 60, 17, 'All Puppies Reserved?', 'reserved', 'small', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Show On Web', 18, 14, 1, 90, 17, 'Show On Web', 'showonweb', 'small', '', 'No', 'No', 0, '', NULL, 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes'),
    ('Puppy Gallery', 18, 14, 2, 10, 23, 'Puppy Images', 'image', '', '', 'No', 'No', 0, '', 'jpg,jpeg,png,webp', 150, 'Yes', 'Yes', 'No', 'Yes', 'Yes', 'Yes');

UPDATE `cms_form_field`
SET `sourcesql` = 'SELECT `id`, `name` FROM `products` WHERE `archived` = 0 ORDER BY `name`'
WHERE `form` = 18 AND `name` IN ('sire', 'dam');

UPDATE `cms_form_field`
SET `mediatype` = 'images', `file_folder_name` = 'dogs', `resize_status` = 'Yes',
    `lg_max_width` = 1400, `md_max_width` = 700, `sm_max_width` = 300, `xs_max_width` = 75
WHERE `form` = 18 AND `name` = 'image';

UPDATE `layout`
SET `url` = 'content-litters.php'
WHERE `id` = 10 AND `name` = 'Litters Due — holding layout';
