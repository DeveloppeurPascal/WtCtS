<?php
	// WtCtS
	// https://wtcts.olfsoftware.fr
	//
	// (c) 2016-2023 Patrick Prémartin / Olf Software

	if (file_exists(__DIR__."/config-prod.inc.php")) {
		require_once(__DIR__."/config-prod.inc.php");
	}
	else if (file_exists(__DIR__."/config-dev.inc.php")) {
		require_once(__DIR__."/config-dev.inc.php");
	}

	// database server name or IP (localhost or other)
	if (!defined("DB_HOST"))
		define("DB_HOST", "");

	// database name
	if (!defined("DB_NAME"))
		define("DB_NAME", "");

	// database user name
	if (!defined("DB_USER"))
		define("DB_USER", "");

	// database user password
	if (!defined("DB_PASS"))
		define("DB_PASS", "");

	// Hash code for lati/long URL verif
	if (!defined("CHashCode"))
		define("CHashCode", "");
