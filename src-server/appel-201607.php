<?php
	// WtCtS
	// https://wtcts.olfsoftware.fr
	//
	// (c) 2016-2023 Patrick Prémartin / Olf Software

	// Appel du programme :
	//		https://api.wtcts.olfsoftware.fr/appel-201607.php?latitude=XXX&longitude=XXX&verif=XXX

	$erreur = false;
	$latitude = 0;
	$longitude = 0;
	$verif = "";
	if (isset($_GET["latitude"])) {
		$sLati = $_GET["latitude"];
		$latitude = floatval(str_replace(",",".",$sLati));
	}
	else {
		$erreur = true;
	}
	if (isset($_GET["longitude"])) {
		$sLongi = $_GET["longitude"];
		$longitude = floatval(str_replace(",",".",$sLongi));
	}
	else {
		$erreur = true;
	}
	if (isset($_GET["verif"])) {
		require_once(__DIR__."/protected-qEcmEAy36i9wo/config.inc.php");
		$erreur = ($_GET["verif"] != md5($sLati.$sLongi.CHashCode));
	}
	else {
		$erreur = true;
	}
	if (! $erreur) {
		require_once(__DIR__."/protected-qEcmEAy36i9wo/db.inc.php");
		if (! $error_exists) {
			try {
				$req = $pdo->prepare("insert into donneesgps (dateheure,latitude,longitude) values (:dh,:lat,:lon)");
				$req->execute(array("dh"=>time(),"lat"=>$latitude,"lon"=>$longitude));
			}
			catch (PDOException $e) {
				$error_exists = true;
				$error_pdo =  "Database error: " . $e->getMessage();
			}
			if (! $error_exists) {
				print("OK");
				exit;
			}
		}
	}
	print("KO");
	exit;
