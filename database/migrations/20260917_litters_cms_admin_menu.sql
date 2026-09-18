-- Litters CMS navigation using Font Awesome's classic solid paw icon.

INSERT INTO `icons`
    (`code`, `codev6`, `iconfamilyv7`, `iconstylev7`, `iconcodev7`, `free`, `charcode`, `name`, `title`, `colour`, `textcolour`, `order`, `useincms`, `showonweb`, `archived`)
VALUES
    ('fas fa-paw', 'fa-solid fa-paw', 'fa-solid', 'classic', 'fa-paw', 'Yes', 'f1b0', 'Paw', 'Litters', '#333333', '#FFFFFF', 20, 'Yes', 'Yes', 0);

INSERT INTO `cms_admin-menu`
    (`title`, `form`, `section`, `subsection`, `url`, `var1`, `target`, `icon`, `userrole`, `showonweb`, `archived`)
VALUES
    ('Litters', 18, 28, 0, NULL, NULL, '', (SELECT `id` FROM `icons` WHERE `name` = 'Paw' AND `iconcodev7` = 'fa-paw' ORDER BY `id` DESC LIMIT 1), 'User', 'Yes', 0),
    ('All Litters', 18, 28, 10, 'recordViewv4.php', NULL, '', (SELECT `id` FROM `icons` WHERE `name` = 'Paw' AND `iconcodev7` = 'fa-paw' ORDER BY `id` DESC LIMIT 1), 'User', 'Yes', 0);
