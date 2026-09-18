-- Rename the public Dogs listing page from /horses to /dogs.
UPDATE `pages`
SET `name` = 'Dogs', `slug` = 'dogs'
WHERE `id` = 5 AND `slug` = 'horses';
