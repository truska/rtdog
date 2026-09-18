-- Dedicated WCCMS records for grouping and uploading public site-gallery images.
CREATE TABLE `gallery_batch` (
    `id` INT(16) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `sort` INT(11) NOT NULL DEFAULT 0,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `archived` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `gallery_batch_archived` (`archived`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `cms_table` (`id`, `title`, `name`, `showonweb`)
VALUES (46, 'Gallery Batches', 'gallery_batch', 'Yes');

INSERT INTO `cms_form`
    (`id`, `title`, `name`, `table`, `col1`, `col1name`, `col1type`, `col4type`, `col5type`, `col6type`,
     `sort1`, `sort1order`, `sort2order`, `viewnotes`, `gallery`, `gallery_table`, `afterAdd`, `afterEdit`,
     `issortable`, `sortcol`, `where1`, `maxgalleryimage`,
     `showcopy`, `showdelete`, `showsearch`, `showarchived`, `showonweb`)
VALUES
    (19, 'Gallery Batches', 'gallery_batch', 46, 'name', 'Batch name', 'Search', 'None', 'None', 'None',
     'id', 'DESC', 'ASC', '', 'Yes', 'gallery', 'recordEditv4.php?frm=[frm]&id=[id]', 'recordEditv4.php?frm=[frm]&id=[id]',
     'No', '', '', 100,
     'Yes', 'Yes', 'Yes', 'No', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`,
     `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Batch Name', 19, 46, 1, 10, 1, 'Batch name', 'name', 'medium', 'e.g. Autumn walk 2026',
     'Yes', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`,
     `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Sort Order', 19, 46, 1, 20, 9, 'Sort order', 'sort', 'small', '0',
     'Yes', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `mediatype`, `file_folder_name`, `file_ext`,
     `resize_status`, `default-resize`, `lg_max_width`, `md_max_width`, `sm_max_width`, `xs_max_width`,
     `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Gallery Images', 19, 46, 2, 10, 23, 'Gallery images', 'image', '', '',
     'No', 'No', 0, '', 'images', 'gallery', 'jpg,jpeg,png,webp',
     'Yes', 150, 1600, 1000, 500, 150,
     'Yes', 'No', 'No', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_actions` (`form`, `action`, `sort`, `showonweb`)
VALUES
    (19, 1, 1, 'Yes'),
    (19, 2, 2, 'Yes'),
    (19, 3, 3, 'Yes'),
    (19, 4, 4, 'Yes'),
    (19, 6, 5, 'Yes');

INSERT INTO `cms_admin-menu`
    (`title`, `form`, `section`, `subsection`, `url`, `var1`, `target`, `icon`, `userrole`, `showonweb`, `archived`)
VALUES
    ('Gallery Batches', 19, 29, 0, NULL, NULL, '', 77, 'User', 'Yes', 0),
    ('All Gallery Batches', 19, 29, 10, 'recordViewv4.php', NULL, '', 77, 'User', 'Yes', 0);

-- Product images were only used to test the public gallery. Future selected images
-- are uploaded through form 19 and selected with the existing gallery checkbox.
UPDATE `gallery`
SET `includeingallery` = 'No'
WHERE `form_id` <> 19 AND `includeingallery` = 'Yes';
