<?php


function __autoload($class_name) {
    include ('../lib/'.$class_name.'.class.php');
} 
$db = new db();

include_once('module/tree.php'); 

include_once('tpl/pages/tree.tpl'); 
