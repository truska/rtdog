<!-- START footer -->
<style>
    .footer {
        background-color: var(--menu-top-bg);
        color: #fff;
        margin-top: 50px;
        padding: 2rem 0;
        font-size: 0.95rem;
    }

    .footer a {
        color: #ddd;
        text-decoration: none;
        transition: color 0.2s ease;
    }

    .footer a:hover,
    .footer a:focus {
        color: yellow;
        text-decoration: none;
    }

    .footer ul {
        list-style: none;
        padding-left: 0;
        margin: 0;
    }

    .footer li {
        margin-bottom: 0.25rem;
        text-transform: uppercase;
    }

    .footer .contact-info p {
        margin-bottom: 0.25rem;
    }

    .footer .social-icons a {
        display: inline-block;
        margin-right: 0.75rem;
        font-size: 3rem;
        color: #fff;
    }

    .footer .social-icons a:hover {
        color: var(--brandred, yellow);
    }
    /* NEW — restore normal text size for non-icon links inside social section */
    .footer .social-icons .email-link,
    .footer .social-icons div a {
        font-size: 0.95rem;
        color: #ddd;
    }
    .footer .social-logo {
        display: block;
        width: 175px;
        max-width: 100%;
        height: auto;
        margin-top: 0.75rem;
        margin-left: auto;
    }

    @media (min-width: 768px) {
        .footer .social-logo {
            margin-top: 0;
            padding-top: 3.5rem;
        }
    }

    .footer-bottom {
        border-top: 1px solid rgba(255,255,255,0.2);
        margin-top: 2rem;
        padding-top: 1rem;
        font-size: 0.85rem;
    }

    .footer-bottom .left {
        text-align: left;
    }

    .footer-bottom .right {
        text-align: right;
    }

    @media (max-width: 767px) {
        .footer-bottom .left,
        .footer-bottom .right {
            text-align: center;
            margin-bottom: 0.75rem;
        }
    }
</style>

<div class="footer">
    <div class="container">
        <div class="row">

            <!-- Footer contact column -->
            <div class="col-6 mb-4 mb-md-0 contact-info">
                <h4>Find Us</h4>

                <p>
                    <i class="fa-solid fa-location-dot"></i>&nbsp;&nbsp;
                    <?= getAddressShort($prefs); ?>
                </p>

                <p>
                    <a href="tel:<?= str_replace(' ', '', getTel1Int($prefs)); ?>">
                        <i class="fa-solid fa-phone"></i>&nbsp;&nbsp;
                        <?= getTel1($prefs); ?>
                    </a>
                </p>

                <?php if (getEmail($prefs)) : ?>
                    <p>
                        <a href="mailto:<?= getEmail($prefs); ?>" target="_blank">
                            <i class="fa-solid fa-at"></i>&nbsp;&nbsp;
                            <span class="d-none d-md-inline"><?= getEmail($prefs); ?></span>
                            <span class="d-inline d-md-none">Email</span>
                        </a>
                    </p>
                <?php endif; ?>
            </div>

            <!-- Footer social column -->
            <div class="col-6 social-icons text-md-end">
                <h4>Find us in Socials</h4>

                <?php
                    if ($prefs['prefFacebookURL']) {
                        echo "<a href='".$prefs['prefFacebookURL']."' target='_blank'><i class='".$prefs['prefFacebookImage']."'></i></a>";
                    }
                    if ($prefs['prefInstagramURL']) {
                        echo "<a href='".$prefs['prefInstagramURL']."' target='_blank'><i class='".$prefs['prefInstagramImage']."'></i></a>";
                    }
                    if ($prefs['prefTwitterURL']) {
                        echo "<a href='".$prefs['prefTwitterURL']."' target='_blank'><i class='".$prefs['prefTwitterImage']."'></i></a>";
                    }
                    if ($prefs['prefLinkedinURL']) {
                        echo "<a href='".$prefs['prefLinkedinURL']."' target='_blank'><i class='".$prefs['prefLinkedinImage']."'></i></a>";
                    }
                ?>
                <?php
                    require_once __DIR__ . '/shared-images.php';
                    $footerImage = sharedImage('footer-sponsor', $baseURL) ?? [
                        'src' => 'https://rtdog.witecanvas.com/filestore/images/content/md/3-2_home-page-welcome_1.png',
                        'alt' => 'Royal Canin',
                    ];
                ?>
                <img class="social-logo"
                     src="<?= htmlspecialchars($footerImage['src'], ENT_QUOTES, 'UTF-8'); ?>"
                     alt="<?= htmlspecialchars($footerImage['alt'], ENT_QUOTES, 'UTF-8'); ?>"
                     <?php if (($footerImage['title'] ?? '') !== ''): ?>
                     title="<?= htmlspecialchars($footerImage['title'], ENT_QUOTES, 'UTF-8'); ?>"
                     <?php endif; ?>
                     loading="lazy">
            </div>

        </div>

        <!-- Footer bottom row -->
        <div class="row footer-bottom align-items-center">
            <div class="col-12 col-md-6 left">
                <p>
                    <a href="<?php echo $baseURL; ?>/privacy-policy">Privacy Policy</a> | 
                    <a href="<?php echo $baseURL; ?>/terms-of-use">Terms of Use</a><br>
                    &copy; <?php echo getCompanyName($prefs)." ".$prefs['prefCopyrightStartYear']." - ".date('Y'); ?>
                </p>
            </div>
            <div class="col-12 col-md-6 right">
                <a href="https://truska.com" target="_blank">
                    designed &amp; coded by truska.com
                </a>
                <!--
                    <br>
                    <span>IP: <?php echo $_SERVER['REMOTE_ADDR']; ?> | Prefs: <?php echo $prefs['prefTruskaIP']; ?></span>
                -->
            </div>
        </div>
    </div>
</div>
<!-- END footer -->
