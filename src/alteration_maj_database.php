<?php
/***********************************************************************************
 * @name: Alteration Maj Database
 * @note: Retourne la liste des fichiers de migrations SQL à exécuter
 * @author: Jgauthi <github.com/jgauthi>, created at [20avril2013]
 * @url: https://github.com/jgauthi/tool_mysql_migration_structure
 * @Requirements:
    - PHP version >= 5.6+ (http://php.net)
    - Mysql v5.6+
    - PDO Extension
 * @usage php alteration_maj_database.php "ARG1" "ARG2" "ARG3" "ARG4"
 * @arguments:
    - database_name
    - chemin_dossier_migration_sql_script
    - user
    - pass
    - server (optionnel, localhost by default)
    - port (optionnel, 3306 by default)

 **********************************************************************************/

// Verif avant lancement
if (!isset($argv[1], $argv[2], $argv[3], $argv[4]) || empty($argv[1]) || empty($argv[3])) {
    die('Login de connexion MySQL non fournit'.PHP_EOL);
} elseif (empty($argv[2]) || !is_readable($alterDir = realpath($argv[2]))) {
    die("Chemin '{$argv[2]}' vers le dossier de migration script SQL incorrecte".PHP_EOL);
}

// Connexion base de donnée
$dsn = [];
$dsn[] = 'dbname='.$argv[1];
$dsn[] = 'host='.((!empty($argv[5])) ? $argv[5] : 'localhost');

if (!empty($argv[6])) {
    $dsn[] = 'port='.$argv[6];
}

$pdo = new PDO('mysql:'.implode(';', $dsn), $argv[3], $argv[4], [
    PDO::MYSQL_ATTR_INIT_COMMAND    => 'SET NAMES utf8',
    PDO::ATTR_ERRMODE               => PDO::ERRMODE_EXCEPTION,
]);

// Création de la table dans le cas où elle existera pas
$pdo->exec("CREATE TABLE IF NOT EXISTS `migration_structures`
(
	`file` VARCHAR(255) NOT NULL,
	`dateAdd` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE `file` (`file`)

) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
");

$scriptList = array_map('basename', glob($alterDir.'/*.sql'));
$scriptUsed = $pdo->query("SELECT file FROM `migration_structures` ORDER BY file ASC");

if ($scriptUsed->rowCount() > 0) {
    $maj_effectue = [];
    foreach ($scriptUsed as list($filename)) {
        $maj_effectue[] = $filename;
    }

    // Exclure les scripts déjà lancés
    $liste_maj = array_diff($scriptList, $maj_effectue);
    sort($liste_maj, SORT_STRING);

    // Envoie de la liste des fichiers à lancer
    if (!empty($liste_maj)) {
        echo implode("\n", $liste_maj);
    }

// Si la table est vide, les fichiers de migrations sont considérés comme déjà lancés
} elseif (!empty($scriptList)) {
    $indexFile = [];
    foreach ($scriptList as $filename) {
        $indexFile[$filename] = '("'. addslashes($filename) .'")';
    }
    asort($indexFile);

    $pdo->exec(
        'INSERT INTO `migration_structures` (file) VALUES '.
        implode(', ', $indexFile).';'
    );

} else {
    echo 'Aucun script de migrations à lancer.'.PHP_EOL;
}

$pdo = null; // Close connection