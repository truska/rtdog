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

         $sql = "INSERT INTO " . $table['name'] . " SET ";
         foreach ($record as $key => $value) {
            if ($key != 'id') {
               if ($key == 'showonweb') { // If the field is the showonweb, we set it to No
                  $value = 'No';
               }
               // Preserve NULL and content whitespace when copying database values.
               $sqlValue = $value === null
                  ? 'NULL'
                  : "'" . mysqli_real_escape_string($conn, $value) . "'";
               $sql .= "`$key` = $sqlValue, "; 
            }
         }
         $sql = substr($sql, 0, -2); // remove last comma

         try {
            $response = DB::query($sql);
         } catch (mysqli_sql_exception $exception) {
            error_log('Record copy failed for form ' . $formID . ', record ' . $recordID . ': ' . $exception->getMessage());
            $response = false;
         }
         // Capture this insert's ID before writing the audit log.
         $recordnumber = $response ? mysqli_insert_id($conn) : 0;

         // $action = "Copy Record ". $recordID ." | " . $table['name'];
         // $logtable = $tb;
         // $notes = "";

         $logtable = $table['name'];
         $action = "Copy Record ".$recordID." in Form " . $formID;
         $sqlquery = mysqli_real_escape_string($conn, $sql);
         $notes = "Making a COPY of Record ".$recordID."";
         $username = $_SESSION["useremail"];



         if ($response) {
            saveLogV2($username, $action, $sqlquery, $logtable, 'SUCCESS', $notes, $recordnumber);
      
            echo "<script>
               window.location='recordEditv4.php?frm=$formID&id=$recordnumber&copy=success'
            </script>";
         } else {
            saveLogV2($username, $action, $sqlquery, $logtable, 'FAIL', $notes, 0);

            echo "<script>
               window.location='recordViewv".$prefs["prefCMSVer"].".php?frm=$formID&copy=error'
            </script>";
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