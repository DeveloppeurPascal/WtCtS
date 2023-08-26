<?php
	// WtCtS
	// https://wtcts.olfsoftware.fr
	//
	// (c) 2016-2023 Patrick Prémartin / Olf Software

	require_once(__DIR__."/protected-qEcmEAy36i9wo/config.inc.php");
	
	$error_exists = false;
	$error_pdo = "";
	try {
		$pdo = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME."", DB_USER, DB_PASS, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'"));
	}
	catch (PDOException $e) {
		$error_exists = true;
		$error_pdo =  "Database error: " . $e->getMessage();
	}
