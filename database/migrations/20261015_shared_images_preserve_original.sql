-- Keep full-resolution originals for shared images; generated sizes handle display.
UPDATE cms_form_field ff
INNER JOIN cms_form f ON f.id = ff.form
SET ff.`default-resize` = 0
WHERE f.name = 'shared_image' AND ff.field = 23;
