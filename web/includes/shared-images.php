<?php

require_once __DIR__ . '/../../private/database.php';

/** Resolve a reusable CMS library image. Newest visible upload is the replacement. */
function sharedImage(string $key, string $baseUrl, string $size = 'md'): ?array
{
    $pdo = Database::pdo();
    try {
        $query = $pdo->prepare("SELECT g.image, g.folder_name, g.alttag, s.alt_text
            FROM shared_image s
            INNER JOIN cms_form f ON f.name = 'shared_image' AND f.archived = 0
            INNER JOIN gallery g ON g.record_id = s.id AND g.form_id = f.id
            WHERE s.image_key = ? AND s.archived = 0
                AND g.archived = 0 AND g.showonweb = 'Yes'
            ORDER BY g.id DESC LIMIT 1");
        $query->execute([$key]);
        $image = $query->fetch();
    } catch (PDOException $error) {
        // Allow the templates to be deployed before the library migration.
        if ($error->getCode() === '42S02') {
            return null;
        }
        throw $error;
    }
    if (!$image) {
        return null;
    }
    $folder = trim($image['folder_name'], '/');
    $filename = $image['image'];
    // Never build a filesystem path from traversal segments in stored metadata.
    if (str_contains($folder, '..') || str_contains($folder, '\\') || basename($filename) !== $filename) {
        return null;
    }
    $variant = in_array($size, ['lg', 'md', 'sm', 'xs'], true) ? $size : 'md';
    $relative = $folder . '/' . $filename;
    if (is_file(__DIR__ . '/../filestore/' . $folder . '/' . $variant . '/' . $filename)) {
        $relative = $folder . '/' . $variant . '/' . $filename;
    } elseif (!is_file(__DIR__ . '/../filestore/' . $relative)) {
        return null;
    }
    return [
        'src' => rtrim($baseUrl, '/') . '/filestore/' . implode('/', array_map('rawurlencode', explode('/', $relative))),
        'alt' => trim($image['alttag']) ?: $image['alt_text'],
    ];
}
