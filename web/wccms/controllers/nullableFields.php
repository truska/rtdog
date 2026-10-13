<?php
require_once __DIR__ . '/../../../private/database.php';

/** Blank optional inputs use SQL NULL only when the column permits it. */
function cmsNullableFields(string $table): array
{
    static $tables = [];
    if (!isset($tables[$table])) {
        $statement = Database::pdo()->prepare(
            'SELECT COLUMN_NAME FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND IS_NULLABLE = ?'
        );
        $statement->execute([$table, 'YES']);
        $tables[$table] = array_fill_keys($statement->fetchAll(PDO::FETCH_COLUMN), true);
    }
    return $tables[$table];
}

function cmsShouldSaveNull(array $nullableFields, string $field, mixed $value): bool
{
    return isset($nullableFields[$field]) && ($value === null || $value === '');
}
