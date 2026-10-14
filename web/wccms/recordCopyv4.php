<?php
error_reporting(1);

include('setting/main-top-files.php'); // Added by salva TDR | 16.03.2023

if (!empty($_GET['frm']) && !empty($_GET['id'])) {
   if (!$formID = securityCheck($_GET['frm'], 'number')) {
      die('Error in the form'); // If the user try to insert something different from a number, we kill the script
   }
   if (!$recordID = securityCheck($_GET['id'], 'number')) {
      die('Error in the record'); // If the user try to insert something different from a number, we kill the script
   }

   $sql = "SELECT * FROM `cms_form`
   WHERE `id` = $formID";
   $form = mysqli_fetch_array(DB::query($sql), MYSQLI_ASSOC);

   if ($form) {
      $sql = "SELECT * FROM `cms_table`
      WHERE `id` = " . $form['table'];
      $table = mysqli_fetch_array(DB::query($sql), MYSQLI_ASSOC);

      if ($table) {
         $sql = "SELECT * FROM " . $table['name'] . "
         WHERE id = $recordID";
         $record = mysqli_fetch_array(DB::query($sql), MYSQLI_ASSOC);

         if (!$record) {
            http_response_code(404);
            die('The record you are trying to copy no longer exists. Please return to the content list and select an existing record.');
         }

         $assignments = [];
         $values = [];
         foreach ($record as $key => $value) {
            if ($key === 'id') {
               continue;
            }
            $assignments[] = '`' . str_replace('`', '``', $key) . '` = ?';
            $values[] = $key === 'showonweb' ? 'No' : $value;
         }
         $sql = 'INSERT INTO `' . str_replace('`', '``', $table['name'])
            . '` SET ' . implode(', ', $assignments);

         $statement = null;
         try {
            $statement = mysqli_prepare($conn, $sql);
            if (!$statement) {
               throw new RuntimeException(mysqli_error($conn));
            }
            // MySQLi sends PHP NULL as SQL NULL, including for integer columns.
            if (!mysqli_stmt_bind_param($statement, str_repeat('s', count($values)), ...$values)) {
               throw new RuntimeException(mysqli_stmt_error($statement));
            }
            $response = mysqli_stmt_execute($statement);
            if (!$response) {
               throw new RuntimeException(mysqli_stmt_error($statement));
            }
         } catch (mysqli_sql_exception | RuntimeException $exception) {
            error_log('Record copy failed for form ' . $formID . ', record ' . $recordID . ': ' . $exception->getMessage());
            $response = false;
         } finally {
            if ($statement) {
               mysqli_stmt_close($statement);
            }
         }
         // Capture this insert's ID before writing the audit log.
         $recordnumber = $response ? mysqli_insert_id($conn) : 0;

         // $action = "Copy Record ". $recordID ." | " . $table['name'];
         // $logtable = $tb;
         // $notes = "";

         $logtable = $table['name'];
         $action = "Copy Record ".$recordID." in Form " . $formID;
         $sqlquery = $sql; // saveLogV2 escapes the query itself.
         $notes = "Making a COPY of Record ".$recordID."";
         $username = $_SESSION["useremail"];



         if ($response) {
            try {
               saveLogV2($username, $action, $sqlquery, $logtable, 'SUCCESS', $notes, $recordnumber);
            } catch (mysqli_sql_exception $exception) {
               // The copy already exists: still take the user to its edit page.
               error_log('Record copy audit failed for new record ' . $recordnumber . ': ' . $exception->getMessage());
            }

            echo "<script>
               window.location='recordEditv4.php?frm=$formID&id=$recordnumber&copy=success'
            </script>";
         } else {
            try {
               saveLogV2($username, $action, $sqlquery, $logtable, 'FAIL', $notes, 0);
            } catch (mysqli_sql_exception $exception) {
               error_log('Record copy failure audit failed: ' . $exception->getMessage());
            }
            http_response_code(500);
            echo '<p>The record could not be copied. Please return to the content list. The failure has been logged for investigation.</p>';
            echo '<p><a href="recordViewv4.php?frm=' . (int) $formID . '">Return to content list</a></p>';
         }
      } else {
         die('Error in the table');
      }
   } else {
      http_response_code(404);
      die('Error in the form');
   }
} else {
   die('Error in the params');
}
?>
<!-- END recordCopyv4 -->
