-- Use the current site terminology in the main products CMS form.
UPDATE `cms_table`
SET `title` = 'Dogs'
WHERE `id` = 7 AND `name` = 'products';

UPDATE `cms_form`
SET `title` = 'Dogs - Main Products'
WHERE `id` = 2 AND `name` = 'products';
