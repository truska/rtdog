<?php
// One current announcement below the main menu.  Sort is the primary choice;
// matching sort values fall back to the earliest start date.
$announcementSql = "SELECT `id`, `heading`, `subheading`, `text`, `bgcolor`, `textcolor`
    FROM `announcement`
    WHERE `status` = 'show'
      AND `showonweb` = 'Yes'
      AND `archived` = 0
      AND `showfrom` <= CURDATE()
      AND `showto` >= CURDATE()
    ORDER BY `sort` ASC, `showfrom` ASC, `id` ASC
    LIMIT 1";
$announcementResult = mysqli_query($conn, $announcementSql);
$announcement = $announcementResult ? mysqli_fetch_assoc($announcementResult) : null;

if (!$announcement) {
    return;
}

// Values are CMS managed, but only allow simple colour values into inline CSS.
$background = preg_match('/^(#[0-9a-fA-F]{3,8}|[a-zA-Z]+)$/', (string) $announcement['bgcolor'])
    ? $announcement['bgcolor'] : '#000000';
$colour = preg_match('/^(#[0-9a-fA-F]{3,8}|[a-zA-Z]+)$/', (string) $announcement['textcolor'])
    ? $announcement['textcolor'] : '#ffffff';
$announcementId = (int) $announcement['id'];
$detailsId = 'announcement-details-' . $announcementId;
?>
<aside id="announcement-bar-<?php echo $announcementId; ?>" class="announcement-bar" style="--announcement-bg: <?php echo htmlspecialchars($background, ENT_QUOTES, 'UTF-8'); ?>; --announcement-colour: <?php echo htmlspecialchars($colour, ENT_QUOTES, 'UTF-8'); ?>;" aria-label="Site announcement">
    <div class="container announcement-container">
        <div class="announcement-title-row">
            <span aria-hidden="true"></span>
            <div class="announcement-heading"><?php echo htmlspecialchars((string) $announcement['heading'], ENT_QUOTES, 'UTF-8'); ?></div>
            <button class="announcement-toggle" type="button" aria-label="Show announcement details" aria-expanded="false" aria-controls="<?php echo $detailsId; ?>">
                <i class="fa-solid fa-angles-down" aria-hidden="true"></i>
            </button>
        </div>
        <div class="announcement-details" id="<?php echo $detailsId; ?>" hidden>
            <?php if (trim((string) $announcement['subheading']) !== ''): ?>
                <div class="announcement-subheading"><?php echo htmlspecialchars((string) $announcement['subheading'], ENT_QUOTES, 'UTF-8'); ?></div>
            <?php endif; ?>
            <?php if (trim((string) $announcement['text']) !== ''): ?>
                <div class="announcement-text"><?php echo $announcement['text']; ?></div>
            <?php endif; ?>
        </div>
    </div>
</aside>

<style>
.announcement-bar { background: var(--announcement-bg); color: var(--announcement-colour); width: 100%; }
.announcement-container { padding-top: .45rem; padding-bottom: .45rem; }
.announcement-title-row { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; gap: .75rem; }
.announcement-heading { color: inherit; font-size: 2rem; font-weight: 700; line-height: 1.15; text-align: center; }
.announcement-toggle { justify-self: end; border: 1px solid currentColor; background: transparent; border-radius: .25rem; color: inherit; font: inherit; padding: .2rem .55rem; }
.announcement-toggle:hover, .announcement-toggle:focus { background: rgba(255,255,255,.18); color: inherit; }
.announcement-details { max-width: 850px; margin: .75rem auto .25rem; text-align: center; }
.announcement-subheading { font-size: 1.2rem; font-weight: 600; margin-bottom: .35rem; }
.announcement-text > :last-child { margin-bottom: 0; }
@media (max-width: 767px) { .announcement-heading { font-size: 1.35rem; } .announcement-title-row { gap: .35rem; } .announcement-toggle { font-size: .875rem; } }
</style>
<script>
(() => {
    const bar = document.getElementById('announcement-bar-<?php echo $announcementId; ?>');
    if (!bar) return;
    const button = bar.querySelector('.announcement-toggle');
    const details = bar.querySelector('.announcement-details');
    if (!button || !details) return;
    button.addEventListener('click', () => {
        const expanded = button.getAttribute('aria-expanded') === 'true';
        button.setAttribute('aria-expanded', String(!expanded));
        button.setAttribute('aria-label', expanded ? 'Show announcement details' : 'Hide announcement details');
        button.querySelector('i').className = expanded ? 'fa-solid fa-angles-down' : 'fa-solid fa-angles-up';
        details.hidden = expanded;
    });
})();
</script>
