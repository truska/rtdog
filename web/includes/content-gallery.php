<?php
// Public gallery images are uploaded through Gallery Batches (CMS form 19).
// Batch ordering takes priority, followed by each image's Gallery order.
$gallerySql = "SELECT g.`id`, g.`image`, g.`folder_name`, g.`alttag`, g.`title`, g.`caption`
    FROM `gallery` AS g
    INNER JOIN `gallery_batch` AS b ON b.`id` = g.`record_id`
    WHERE g.`form_id` = 19
      AND g.`showonweb` = 'Yes'
      AND g.`archived` = 0
      AND b.`archived` = 0
    ORDER BY b.`sort` ASC, g.`gallerysort` ASC, g.`id` ASC";
$galleryResult = mysqli_query($conn, $gallerySql);
$galleryImages = $galleryResult ? mysqli_fetch_all($galleryResult, MYSQLI_ASSOC) : [];

if (!$galleryImages) {
    echo "<div class='content-{$rowcontent['id']} container'><p class='text-center text-muted mb-0'>Our gallery is being prepared. Please check back soon.</p></div>";
    return;
}
?>
<section class="content-<?php echo (int) $rowcontent['id']; ?> gallery-section">
    <div class="container">
        <?php if (($rowcontent['showheading'] ?? 'No') === 'Yes' && !empty($rowcontent['heading'])): ?>
            <h2 class="text-center mb-4"><?php echo htmlspecialchars($rowcontent['heading'], ENT_QUOTES, 'UTF-8'); ?></h2>
        <?php endif; ?>
        <?php if (!empty($rowcontent['text'])): ?>
            <div class="gallery-introduction mb-4"><?php echo $rowcontent['text']; ?></div>
        <?php endif; ?>

        <div class="gallery-masonry">
            <?php foreach ($galleryImages as $image):
                $folder = trim((string) $image['folder_name'], '/');
                $basePath = $baseURL . '/filestore/' . $folder;
                $file = rawurlencode((string) $image['image']);
                $localFolder = __DIR__ . '/../filestore/' . $folder;
                // Older uploads may not have generated responsive versions.
                $medium = is_file($localFolder . '/md/' . $image['image']) ? $basePath . '/md/' . $file : $basePath . '/' . $file;
                $large = is_file($localFolder . '/lg/' . $image['image']) ? $basePath . '/lg/' . $file : $basePath . '/' . $file;
                $alt = trim((string) $image['alttag']) ?: trim((string) $image['title']) ?: 'Gallery image';
                $title = trim((string) $image['title']) ?: $alt;
                $caption = trim((string) $image['caption']);
                // Magic Zoom Plus uses the title in its expanded-view caption.
                $zoomCaption = $caption !== '' ? $caption : $title;
            ?>
                <figure class="gallery-masonry-item mb-3">
                    <a class="MagicZoom gallery-image-link"
                       data-gallery="site-gallery"
                       href="<?php echo htmlspecialchars($large, ENT_QUOTES, 'UTF-8'); ?>"
                       title="<?php echo htmlspecialchars($zoomCaption, ENT_QUOTES, 'UTF-8'); ?>"
                       data-options="zoomMode: off; expand: fullscreen; expandZoomMode: off; expandGallery: true; expandThumbs: false; hint: off">
                        <img src="<?php echo htmlspecialchars($medium, ENT_QUOTES, 'UTF-8'); ?>" loading="lazy" alt="<?php echo htmlspecialchars($alt, ENT_QUOTES, 'UTF-8'); ?>">
                    </a>
                    <?php if ($caption !== ''): ?>
                        <figcaption class="gallery-caption pt-2"><?php echo htmlspecialchars($caption, ENT_QUOTES, 'UTF-8'); ?></figcaption>
                    <?php endif; ?>
                </figure>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<style>
.gallery-section { padding-bottom: 3rem; }
.gallery-masonry { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 1rem; }
.gallery-masonry-item { min-width: 0; margin-bottom: 0 !important; }
.gallery-image-link, .gallery-image-link img { display: block; width: 100%; height: auto; }
.gallery-caption { color: #444; font-size: .9375rem; line-height: 1.35; }
@media (max-width: 991px) { .gallery-masonry { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
@media (max-width: 767px) { .gallery-masonry { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: .75rem; } }
</style>
