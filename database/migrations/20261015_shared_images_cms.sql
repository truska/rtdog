-- Shared image library using the existing CMS gallery uploader. Run once.
-- Deployment: create web/filestore/images/shared and xs/sm/md/lg subfolders.
-- Match the working gallery folder ownership and ACLs, including PHP-user write
-- access and default ACL inheritance. Filestore is excluded from Git.
-- On this host the PHP user is web22; apply u:web22:rwx,d:u:web22:rwx to each folder.
CREATE TABLE IF NOT EXISTS `shared_image` (
    `id` INT(16) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `image_key` VARCHAR(64) NOT NULL,
    `alt_text` VARCHAR(255) NOT NULL DEFAULT '',
    UNIQUE KEY `shared_image_key` (`image_key`),
    `sort` INT(11) NOT NULL DEFAULT 0,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `archived` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `shared_image_archived` (`archived`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

START TRANSACTION;
SET @shared_section = (SELECT COALESCE(MAX(section),0)+1 FROM `cms_admin-menu`);
INSERT INTO cms_table (title,name,showonweb)
SELECT 'Shared Images','shared_image','Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_table WHERE name='shared_image');
SET @shared_table = (SELECT id FROM cms_table WHERE name='shared_image' ORDER BY id LIMIT 1);

INSERT INTO `cms_form`
    (`id`, `title`, `name`, `table`, `col1`, `col1name`, `col1type`, `col4type`, `col5type`, `col6type`,
     `sort1`, `sort1order`, `sort2order`, `viewnotes`, `gallery`, `gallery_table`, `afterAdd`, `afterEdit`,
     `issortable`, `sortcol`, `where1`, `maxgalleryimage`,
     `showcopy`, `showdelete`, `showsearch`, `showarchived`, `showonweb`)
VALUES
    (NULL, 'Shared Images', 'shared_image', @shared_table, 'name', 'Image name', 'Search', 'None', 'None', 'None',
     'name', 'ASC', 'ASC', 'Reusable site images. Save a new record before uploading. The newest visible upload is used wherever its image key is referenced. Upload one replacement at a time; older uploads can be deleted afterwards. Library images are separate from the public gallery.', 'Yes', 'gallery', 'recordEditv4.php?frm=[frm]&id=[id]', 'recordEditv4.php?frm=[frm]&id=[id]',
     'No', '', '', 100,
     'No', 'Yes', 'Yes', 'No', 'Yes');
SET @shared_form = LAST_INSERT_ID();

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`,
     `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Image Name', @shared_form, @shared_table, 1, 10, 1, 'Image name', 'name', 'medium', 'e.g. Footer sponsor logo',
     'Yes', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `default-resize`, `override_filename`,
     `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Sort Order', @shared_form, @shared_table, 1, 20, 9, 'Sort order', 'sort', 'small', '0',
     'Yes', 'No', 0, '', 0, 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_field`
    (`title`, `form`, `table`, `tab`, `sort`, `field`, `label`, `name`, `class`, `placeholder`,
     `required`, `selected`, `datatype`, `sourcesqlWHERE`, `mediatype`, `file_folder_name`, `file_ext`,
     `resize_status`, `default-resize`, `lg_max_width`, `md_max_width`, `sm_max_width`, `xs_max_width`,
     `override_filename`, `issortable`, `showadd`, `showedit`, `allowedit`, `showonweb`)
VALUES
    ('Library Image', @shared_form, @shared_table, 2, 10, 23, 'Upload / replace image', 'image', '', '',
     'No', 'No', 0, '', 'images', 'shared', 'jpg,jpeg,png,gif',
     'Yes', 0, 1600, 1000, 500, 150,
     'Yes', 'No', 'No', 'Yes', 'Yes', 'Yes');

INSERT INTO `cms_form_actions` (`form`, `action`, `sort`, `showonweb`)
VALUES
    (@shared_form, 1, 1, 'Yes'),
    (@shared_form, 2, 2, 'Yes'),
    (@shared_form, 3, 3, 'Yes'),
    (@shared_form, 4, 4, 'Yes'),
    (@shared_form, 6, 5, 'Yes');

INSERT INTO `cms_admin-menu`
    (`title`, `form`, `section`, `subsection`, `url`, `var1`, `target`, `icon`, `userrole`, `showonweb`, `archived`)
VALUES
    ('Shared Images', @shared_form, @shared_section, 0, NULL, NULL, '', 77, 'User', 'Yes', 0),
    ('Image Library', @shared_form, @shared_section, 10, 'recordViewv4.php', NULL, '', 77, 'User', 'Yes', 0);


INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
VALUES
('Image Key',@shared_form,@shared_table,15,1,'Image key (keep unchanged once used)','image_key','medium','e.g. footer-sponsor','Yes','No','',0,'No','No','Yes','Yes','Yes','Yes'),
('Alternative Text',@shared_form,@shared_table,25,1,'Alternative text','alt_text','medium','Describe the image','No','No','',0,'No','No','Yes','Yes','Yes','Yes');
INSERT INTO `cms_admin-menu` (title,form,section,subsection,url,target,icon,userrole,showonweb)
VALUES ('Add Shared Image',@shared_form,@shared_section,20,'recordAddv4.php','',77,'User','Yes');
INSERT INTO shared_image (name,image_key,alt_text) VALUES ('Footer sponsor logo','footer-sponsor','Royal Canin');
COMMIT;
