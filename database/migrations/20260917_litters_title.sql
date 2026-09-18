-- Short titles are used for the litter dropdown; headings remain the page H2.
-- Run after 20260917_litters_menu.sql.

ALTER TABLE `litters`
    ADD COLUMN `title` VARCHAR(128) NOT NULL DEFAULT '' AFTER `born`;

UPDATE `litters`
SET `title` = `heading`
WHERE `title` = '';

UPDATE `cms_form`
SET `col1` = 'title', `col1name` = 'Menu Title', `col1type` = 'Search',
    `col2` = 'heading', `col2name` = 'Heading', `col2type` = 'Search',
    `col3` = 'dob', `col3name` = 'Date of Birth', `col3table` = '', `col3type` = 'Search',
    `col4` = 'sire', `col4name` = 'Sire', `col4table` = 'products', `col4type` = 'Search',
    `col5` = 'dam', `col5name` = 'Dam', `col5table` = 'products', `col5type` = 'Search',
    `col6` = 'showonmenu', `col6name` = 'Show On Menu', `col6table` = '', `col6type` = 'Select'
WHERE `id` = 18;

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Menu Title', 18, 14, 1, 5, 1, 'Title (used on menu)', 'title', 'medium', '', 'Yes', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');
