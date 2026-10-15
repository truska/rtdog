-- Announcement CMS setup. Run on dev first, then live after review/testing.
-- Uses existing announcement records; does not publish or alter their values.
-- Defaults allow Add to submit only heading/showfrom/showto under strict SQL mode.
ALTER TABLE `announcement`
 ALTER COLUMN `subheading` SET DEFAULT '',
 ALTER COLUMN `text` SET DEFAULT '',
 ALTER COLUMN `subheading1` SET DEFAULT '',
 ALTER COLUMN `text1` SET DEFAULT '',
 ALTER COLUMN `sort` SET DEFAULT 10,
 ALTER COLUMN `bgcolor` SET DEFAULT '#000000',
 ALTER COLUMN `textcolor` SET DEFAULT '#ffffff',
 ALTER COLUMN `iconopencolor` SET DEFAULT '#008000',
 ALTER COLUMN `iconclosecolor` SET DEFAULT '#ff0000';

START TRANSACTION;
INSERT INTO cms_table (title,name,showonweb)
SELECT 'Announcements','announcement','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_table WHERE name='announcement');
SET @announcement_table = (SELECT id FROM cms_table WHERE name='announcement' ORDER BY id LIMIT 1);
INSERT INTO cms_form
(title,name,`table`,col1,col1name,col1type,col2,col2name,col2type,col3,col3name,col3type,col4,col4type,col5,col5type,col6,col6type,
sort1,sort1order,sort2,sort2order,viewnotes,afterAdd,afterEdit,sortcol,where1,showsearch,showarchived,gallery)
SELECT 'Announcements','announcement',@announcement_table,'heading','Heading','Search','showfrom','Show From','Search','showto','Show To','Search','status','Select','showonweb','Select','sort','Search',
'sort','ASC','showfrom','ASC','Announcements are shown only when Status is show, Show On Web is Yes, and today is within the date range.',
'recordEditv4.php?frm=[frm]&id=[id]','recordEditv4.php?frm=[frm]&id=[id]','','','Yes','No','No'
WHERE NOT EXISTS (SELECT 1 FROM cms_form WHERE name='announcement');
SET @announcement_form = (SELECT id FROM cms_form WHERE name='announcement' ORDER BY id LIMIT 1);
-- In this CMS, Yes means archived records ONLY. The main listing needs No.
UPDATE cms_form SET showarchived='No' WHERE id=@announcement_form;

INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Heading',@announcement_form,@announcement_table,10,1,'Heading','heading','medium','','Yes','No','',0,'No','No','Yes','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='heading');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Show From',@announcement_form,@announcement_table,20,22,'Show From','showfrom','medium','','Yes','No','',0,'No','No','Yes','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='showfrom');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Show To',@announcement_form,@announcement_table,30,22,'Show To','showto','medium','','Yes','No','',0,'No','No','Yes','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='showto');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Subheading',@announcement_form,@announcement_table,40,1,'Subheading','subheading','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='subheading');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Details',@announcement_form,@announcement_table,50,19,'Details','text','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='text');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Additional Subheading',@announcement_form,@announcement_table,60,1,'Additional Subheading','subheading1','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='subheading1');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Additional Details',@announcement_form,@announcement_table,70,19,'Additional Details','text1','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='text1');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Image ID',@announcement_form,@announcement_table,80,9,'Image ID','image','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='image');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Sort Order',@announcement_form,@announcement_table,90,9,'Sort Order','sort','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='sort');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Status',@announcement_form,@announcement_table,100,16,'Status','status','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='status');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Background Colour',@announcement_form,@announcement_table,110,5,'Background Colour','bgcolor','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='bgcolor');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Text Colour',@announcement_form,@announcement_table,120,5,'Text Colour','textcolor','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='textcolor');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Open Icon Colour',@announcement_form,@announcement_table,130,5,'Open Icon Colour','iconopencolor','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='iconopencolor');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Close Icon Colour',@announcement_form,@announcement_table,140,5,'Close Icon Colour','iconclosecolor','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='iconclosecolor');
INSERT INTO cms_form_field
(title,form,`table`,sort,field,label,name,class,placeholder,required,selected,sourcesqlWHERE,`default-resize`,override_filename,issortable,showadd,showedit,allowedit,showonweb)
SELECT 'Show On Web',@announcement_form,@announcement_table,150,17,'Show On Web','showonweb','medium','','No','No','',0,'No','No','No','Yes','Yes','Yes'
WHERE NOT EXISTS (SELECT 1 FROM cms_form_field WHERE form=@announcement_form AND name='showonweb');
SET @announcement_status = (SELECT id FROM cms_form_field WHERE form=@announcement_form AND name='status' ORDER BY id LIMIT 1);
INSERT INTO cms_form_field_options (form_field,value,checked,display,sort) SELECT @announcement_status,'hide','No','Hide',1 WHERE NOT EXISTS (SELECT 1 FROM cms_form_field_options WHERE form_field=@announcement_status AND value='hide');
INSERT INTO cms_form_field_options (form_field,value,checked,display,sort) SELECT @announcement_status,'show','No','Show',2 WHERE NOT EXISTS (SELECT 1 FROM cms_form_field_options WHERE form_field=@announcement_status AND value='show');
INSERT INTO cms_form_actions (form,action,sort,showonweb) SELECT @announcement_form,1,1,'Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_form_actions WHERE form=@announcement_form AND action=1);
INSERT INTO cms_form_actions (form,action,sort,showonweb) SELECT @announcement_form,2,2,'Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_form_actions WHERE form=@announcement_form AND action=2);
INSERT INTO cms_form_actions (form,action,sort,showonweb) SELECT @announcement_form,3,3,'Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_form_actions WHERE form=@announcement_form AND action=3);
INSERT INTO cms_form_actions (form,action,sort,showonweb) SELECT @announcement_form,4,4,'Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_form_actions WHERE form=@announcement_form AND action=4);
INSERT INTO cms_form_actions (form,action,sort,showonweb) SELECT @announcement_form,6,5,'Yes' WHERE NOT EXISTS (SELECT 1 FROM cms_form_actions WHERE form=@announcement_form AND action=6);
INSERT INTO `cms_admin-menu` (title,form,section,subsection,url,target,icon,userrole,showonweb) SELECT 'Announcements',@announcement_form,55,0,NULL,'',35,'User','Yes' WHERE NOT EXISTS (SELECT 1 FROM `cms_admin-menu` WHERE form=@announcement_form AND subsection=0);
INSERT INTO `cms_admin-menu` (title,form,section,subsection,url,target,icon,userrole,showonweb) SELECT 'Edit Announcements',@announcement_form,55,10,'recordViewv4.php','',35,'User','Yes' WHERE NOT EXISTS (SELECT 1 FROM `cms_admin-menu` WHERE form=@announcement_form AND subsection=10);
INSERT INTO `cms_admin-menu` (title,form,section,subsection,url,target,icon,userrole,showonweb) SELECT 'Add Announcement',@announcement_form,55,20,'recordAddv4.php','',35,'User','Yes' WHERE NOT EXISTS (SELECT 1 FROM `cms_admin-menu` WHERE form=@announcement_form AND subsection=20);
COMMIT;
