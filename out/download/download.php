<?php
require_once("common.php");

$name = mysql_escape_string($_SERVER['QUERY_STRING']);
$file = $downloads[$name]['file'];

if (file_exists($file)) 
{
	mysql_query("INSERT INTO downloads (name, file, ip) VALUES ('$name', '$file', '$_SERVER[REMOTE_ADDR]')", $sql);

	header('Content-Description: File Transfer');
	header('Content-Type: application/octet-stream');
	header('Content-Disposition: attachment; filename='.basename($file));
	header('Content-Transfer-Encoding: binary');
	header('Expires: 0');
	header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
	header('Pragma: public');
	header('Content-Length: ' . filesize($file));
	ob_clean();
	flush();
	readfile($file);
}

mysql_close($sql);
