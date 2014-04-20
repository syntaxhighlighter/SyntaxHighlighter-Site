<?php
$HOME = dirname(__FILE__);
$downloads = array();

$mysql_type		= "mysql";
$mysql_server	= "mysql.alexgorbatchev.com";
$mysql_name		= "alexgorbatchev_wiki";
$mysql_user		= "alexgorbatchev";
$mysql_password	= "zxcvbnm";

$sql = mysql_connect($mysql_server, $mysql_user, $mysql_password);
mysql_select_db($mysql_name, $sql);

$downloads['sh_2.0.278'] = array('file' => 'syntaxhighlighter_2.0.278.zip');
$downloads['sh_2.0.287'] = array('file' => 'syntaxhighlighter_2.0.287.zip');
$downloads['sh_2.0.296'] = array('file' => 'syntaxhighlighter_2.0.296.zip');
$downloads['sh_2.0.320'] = array('file' => 'syntaxhighlighter_2.0.320.zip');
$downloads['sh_2.1.364'] = array('file' => 'syntaxhighlighter_2.1.364.zip');
$downloads['sh_2.1.382'] = array('file' => 'syntaxhighlighter_2.1.382.zip');

$downloads['sh_current'] = array('file' => 'syntaxhighlighter_3.0.83.zip');
