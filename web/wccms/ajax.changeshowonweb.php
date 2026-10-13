<?php
require_once __DIR__ . '/include/session.php';
header('Content-Type: application/json');

function visibilityResponse(int $status, string $message): void
{
    http_response_code($status);
    echo json_encode(['message' => $message]);
    exit;
}

if (!isset($_SESSION['useremail'])) {
    visibilityResponse(401, 'Login required.');
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    visibilityResponse(405, 'POST required.');
}
if (!is_string($_POST['csrf'] ?? null) ||
    empty($_SESSION['gallery_visibility_csrf']) ||
    !hash_equals($_SESSION['gallery_visibility_csrf'], $_POST['csrf'])) {
    visibilityResponse(403, 'Invalid session token.');
}

$imageId = filter_var($_POST['imgid'] ?? null, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
$formId = filter_var($_POST['formid'] ?? null, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
$recordId = filter_var($_POST['recordid'] ?? null, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
$state = $_POST['state'] ?? '';
if (!$imageId || !$formId || !$recordId || !in_array($state, ['Yes', 'No'], true)) {
    visibilityResponse(400, 'Invalid image or visibility value.');
}

require_once __DIR__ . '/../../private/database.php';
try {
    $pdo = Database::pdo();
    $find = $pdo->prepare('SELECT id FROM gallery WHERE id = ? AND form_id = ? AND record_id = ? AND archived = 0');
    $find->execute([$imageId, $formId, $recordId]);
    if (!$find->fetchColumn()) {
        visibilityResponse(404, 'Image not found in this record.');
    }
    $update = $pdo->prepare('UPDATE gallery SET showonweb = ? WHERE id = ? AND form_id = ? AND record_id = ? AND archived = 0');
    $update->execute([$state, $imageId, $formId, $recordId]);
    visibilityResponse(200, 'Visibility saved.');
} catch (Throwable $error) {
    error_log('Gallery visibility save failed: ' . $error->getMessage());
    visibilityResponse(500, 'Could not save visibility.');
}
