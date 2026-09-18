<?php
// Litters Due: page copy from the content record followed by published litters.
$litterFormId = 18;

/** Return a safe image path using the folder saved with the gallery item. */
function litterGalleryImagePath(array $image, string $size): string
{
    $folder = trim((string) ($image['folder_name'] ?? 'dogs'), '/');
    $folder = preg_replace('#^(?:filestore/)?images/#', '', $folder) ?: 'dogs';
    return getValidImagePath((string) ($image['image'] ?? ''), $folder, $size);
}

/** Print the first published image for a parent, or the normal no-image fallback. */
function renderLitterParentImage(mysqli $conn, int $parentId, string $baseURL, string $alt): void
{
    $stmt = mysqli_prepare($conn, "SELECT image, folder_name FROM gallery WHERE form_id = 2 AND record_id = ? AND showonweb = 'Yes' AND archived = 0 ORDER BY sort ASC, id ASC LIMIT 1");
    mysqli_stmt_bind_param($stmt, 'i', $parentId);
    mysqli_stmt_execute($stmt);
    $image = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt)) ?: [];
    mysqli_stmt_close($stmt);

    $path = litterGalleryImagePath($image, 'md');
    echo "<img class='img-fluid w-100' src='" . htmlspecialchars($baseURL . $path, ENT_QUOTES) . "' alt='" . htmlspecialchars($alt, ENT_QUOTES) . "'>";
}

echo "<div class='container py-4 parent-element'>";
echo '<style>@media (min-width: 768px) { .litter-parent-heading { min-height: 7rem; } }</style>';
showEditButton(3, $rowcontent['id']);
echo "<div class='row'>";
echo "<div class='col-12 content-{$rowcontent['id']}'>";
if (($rowcontent['showheading'] ?? 'Yes') === 'Yes') {
    echo '<h1>' . htmlspecialchars((string) $rowcontent['heading']) . '</h1>';
}
if (!empty($rowcontent['text'])) {
    echo $rowcontent['text'];
}
echo '</div>';
echo '</div>';

$selectedLitterId = isset($segs[1]) && ctype_digit((string) $segs[1]) ? (int) $segs[1] : 0;
$selectedLitterWhere = $selectedLitterId > 0 ? " AND l.id = {$selectedLitterId}" : '';

$sql = "SELECT l.*,
               s.id AS sire_product_id, s.slug AS sire_slug, COALESCE(NULLIF(s.nameoverride, ''), s.name) AS sire_name,
               d.id AS dam_product_id, d.slug AS dam_slug, COALESCE(NULLIF(d.nameoverride, ''), d.name) AS dam_name
        FROM litters l
        LEFT JOIN products s ON s.id = l.sire AND s.archived = 0
        LEFT JOIN products d ON d.id = l.dam AND d.archived = 0
        WHERE l.showonweb = 'Yes' AND l.archived = 0{$selectedLitterWhere}
        ORDER BY l.dob DESC, l.id DESC";
$litters = mysqli_query($conn, $sql);

if ($litters && mysqli_num_rows($litters) === 0) {
    echo $selectedLitterId > 0
        ? "<p class='mt-4 text-muted'>This litter is not available.</p>"
        : "<p class='mt-4 text-muted'>There are no litters to show at present.</p>";
}

while ($litter = $litters ? mysqli_fetch_assoc($litters) : null) {
    if ($litter === null) {
        break;
    }
    $litterId = (int) $litter['id'];
    $heading = trim((string) $litter['heading']);
    $sireName = trim((string) ($litter['sire_name'] ?: 'Sire to be confirmed'));
    $damName = trim((string) ($litter['dam_name'] ?: 'Dam to be confirmed'));
    $dogRoute = getProductDetailRoute($conn);
    $sireLink = !empty($litter['sire_product_id']) && $dogRoute !== ''
        ? $baseURL . '/' . $dogRoute . '/' . (int) $litter['sire_product_id'] . '/' . rawurlencode((string) $litter['sire_slug'])
        : '';
    $damLink = !empty($litter['dam_product_id']) && $dogRoute !== ''
        ? $baseURL . '/' . $dogRoute . '/' . (int) $litter['dam_product_id'] . '/' . rawurlencode((string) $litter['dam_slug'])
        : '';

    $imageStmt = mysqli_prepare($conn, "SELECT image, folder_name, alttag, caption FROM gallery WHERE form_id = ? AND record_id = ? AND showonweb = 'Yes' AND archived = 0 ORDER BY sort ASC, id ASC");
    mysqli_stmt_bind_param($imageStmt, 'ii', $litterFormId, $litterId);
    mysqli_stmt_execute($imageStmt);
    $imageResult = mysqli_stmt_get_result($imageStmt);
    $puppyImages = mysqli_fetch_all($imageResult, MYSQLI_ASSOC);
    mysqli_stmt_close($imageStmt);
    ?>
    <section id="litter-<?= $litterId ?>" class="mt-5">
        <?php if ($heading !== ''): ?>
            <h2 class="mb-3"><?= htmlspecialchars($heading) ?></h2>
        <?php endif; ?>
        <?php if (!empty($litter['text'])): ?>
            <div class="mb-3"><?= $litter['text'] ?></div>
        <?php endif; ?>
        <div class="row g-4 align-items-start">
            <div class="col-12 col-md-3">
                <div class="litter-parent-heading mb-3">
                    <span class="badge rounded-pill text-bg-secondary d-inline-block mb-2">Sire</span>
                    <h3 class="mb-0"><?= htmlspecialchars($sireName) ?></h3>
                </div>
                <?php renderLitterParentImage($conn, (int) $litter['sire'], $baseURL, $sireName); ?>
                <?php if ($sireLink !== ''): ?>
                    <a class="btn btn-sm btn-outline-secondary rounded-pill mt-3" href="<?= htmlspecialchars($sireLink, ENT_QUOTES) ?>">View Sire</a>
                <?php endif; ?>
            </div>
            <div class="col-12 col-md-3">
                <div class="litter-parent-heading mb-3">
                    <span class="badge rounded-pill text-bg-secondary d-inline-block mb-2">Dam</span>
                    <h3 class="mb-0"><?= htmlspecialchars($damName) ?></h3>
                </div>
                <?php renderLitterParentImage($conn, (int) $litter['dam'], $baseURL, $damName); ?>
                <?php if ($damLink !== ''): ?>
                    <a class="btn btn-sm btn-outline-secondary rounded-pill mt-3" href="<?= htmlspecialchars($damLink, ENT_QUOTES) ?>">View Dam</a>
                <?php endif; ?>
            </div>
            <div class="col-12 col-md-6">
                <?php if (count($puppyImages) > 0):
                    $mainImage = $puppyImages[0];
                    $zoomId = 'litter-zoom-' . $litterId;
                    $mainAlt = (string) ($mainImage['alttag'] ?: $heading);
                    $mainCaption = (string) ($mainImage['caption'] ?: $heading);
                ?>
                    <a class="MagicZoom"
                       id="<?= htmlspecialchars($zoomId, ENT_QUOTES) ?>"
                       href="<?= htmlspecialchars($baseURL . litterGalleryImagePath($mainImage, 'lg'), ENT_QUOTES) ?>"
                       title="<?= htmlspecialchars($mainCaption, ENT_QUOTES) ?>"
                       data-options="zoomMode: off; expand: fullscreen; expandZoomMode: off; hint: off">
                        <img class="img-fluid w-100" src="<?= htmlspecialchars($baseURL . litterGalleryImagePath($mainImage, 'md'), ENT_QUOTES) ?>" alt="<?= htmlspecialchars($mainAlt, ENT_QUOTES) ?>">
                    </a>
                <?php endif; ?>

                <?php if (count($puppyImages) > 1): ?>
                    <div class="row g-3 pt-3">
                        <?php foreach ($puppyImages as $image): ?>
                            <?php
                            $imageAlt = (string) ($image['alttag'] ?: $heading);
                            $imageCaption = (string) ($image['caption'] ?: $heading);
                            ?>
                            <div class="col-3">
                                <a data-zoom-id="<?= htmlspecialchars($zoomId, ENT_QUOTES) ?>"
                                   href="<?= htmlspecialchars($baseURL . litterGalleryImagePath($image, 'lg'), ENT_QUOTES) ?>"
                                   data-image="<?= htmlspecialchars($baseURL . litterGalleryImagePath($image, 'md'), ENT_QUOTES) ?>"
                                   title="<?= htmlspecialchars($imageCaption, ENT_QUOTES) ?>">
                                    <img class="img-fluid w-100" src="<?= htmlspecialchars($baseURL . litterGalleryImagePath($image, 'sm'), ENT_QUOTES) ?>" alt="<?= htmlspecialchars($imageAlt, ENT_QUOTES) ?>">
                                </a>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </section>
    <?php
}
echo '</div>';
