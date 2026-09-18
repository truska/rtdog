-- Litter menu visibility and the standard CMS record actions.
-- Run after 20260917_litters.sql.

ALTER TABLE `litters`
    ADD COLUMN `showonmenu` ENUM('Yes','No') NOT NULL DEFAULT 'No' AFTER `showonweb`,
    ADD KEY `litters_menu` (`showonmenu`, `showonweb`, `archived`);

UPDATE `cms_form`
SET `col6` = 'showonmenu', `col6name` = 'Show On Menu', `col6type` = 'Select'
WHERE `id` = 18;

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`, `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Show On Menu', 18, 14, 1, 95, 17, 'Show Litter Heading On Menu', 'showonmenu', 'small', '', 'No', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_actions` (`form`, `action`, `sort`, `showonweb`)
VALUES
    (18, 1, 1, 'Yes'),
    (18, 2, 2, 'Yes'),
    (18, 3, 3, 'Yes'),
    (18, 4, 4, 'Yes'),
    (18, 6, 5, 'Yes');

UPDATE `menu`
SET `table` = 14
WHERE `id` = 5 AND `page` = 11;
