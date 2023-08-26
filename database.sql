CREATE TABLE `donneesgps` (
  `code` int(10) UNSIGNED NOT NULL,
  `dateheure` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `latitude` decimal(10,0) NOT NULL DEFAULT 0,
  `longitude` decimal(10,0) NOT NULL DEFAULT 0
);

ALTER TABLE `donneesgps`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `dateheure` (`dateheure`,`code`);

ALTER TABLE `donneesgps`
  MODIFY `code` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
