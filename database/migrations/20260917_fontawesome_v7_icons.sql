-- Font Awesome v7 metadata and the CMS Dogs menu icon.
-- v7 renders as: iconfamilyv7 + iconstylev7 + iconcodev7.

UPDATE `icons`
SET
    `iconfamilyv7` = CASE SUBSTRING_INDEX(`code`, ' ', 1)
        WHEN 'fas' THEN 'fa-solid'
        WHEN 'far' THEN 'fa-regular'
        WHEN 'fab' THEN 'fa-brands'
        WHEN 'fal' THEN 'fa-light'
    END,
    `iconstylev7` = 'classic',
    `iconcodev7` = SUBSTRING_INDEX(`code`, ' ', -1)
WHERE (`iconcodev7` IS NULL OR `iconcodev7` = '')
  AND `code` REGEXP '^(fas|far|fab|fal) fa-[a-z0-9-]+$';

INSERT INTO `icons`
    (`code`, `codev6`, `iconfamilyv7`, `iconstylev7`, `iconcodev7`, `free`, `charcode`, `name`, `title`, `colour`, `textcolour`, `order`, `useincms`, `showonweb`, `archived`)
VALUES
    ('fas fa-dog', 'fa-solid fa-dog', 'fa-solid', 'classic', 'fa-dog', 'Yes', 'f6d3', 'Dog', 'Dog', '#333333', '#FFFFFF', 20, 'Yes', 'Yes', 0);

UPDATE `cms_admin-menu`
SET `icon` = (SELECT `id` FROM `icons` WHERE `name` = 'Dog' AND `iconcodev7` = 'fa-dog' ORDER BY `id` DESC LIMIT 1)
WHERE `id` = 7 AND `title` = 'Dogs';
