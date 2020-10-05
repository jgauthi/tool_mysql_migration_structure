<?php
// Script php pour mettre à jour
// php alteration_maj_database.php "database" "user" "pass" "chemin_dossier_migration_sql_script"


// Verif avant lancement
if (!isset($argv[0], $argv[1], $argv[2], $argv[3], $argv[4]) || empty($argv[1]) || empty($argv[2]) || $argv[0] != basename(__FILE__))
    die('Login de connexion MySQL non fournit');

elseif (empty($argv[4]) || !is_readable($vyset_dir = realpath($argv[4])))
    die("Chemin '{$argv[4]}' vers le dossier de migration script SQL incorrecte");

elseif (!$link = mysql_connect('localhost', $argv[2], $argv[3]))
    die('Impossible de se connecter : ' . mysql_error() );

elseif (!$db_selected = mysql_select_db($argv[1], $link))
    die('Impossible de sélectionner la base de données : ' . mysql_error() );


// Création de la table dans le cas où elle existera pas
mysql_query("CREATE TABLE IF NOT EXISTS `migration_structures`
(
  `id` int(5) unsigned NOT NULL auto_increment,
  `script_name` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
", $link);


// Récupérer la liste des scripts déjà executé
$req = mysql_query("SELECT id, script_name FROM `migration_structures` ORDER BY id", $link);
$maj_effectue = array();

if (mysql_num_rows($req) > 0)
    while($fichier = mysql_fetch_assoc($req))
        $maj_effectue[] = $fichier['script_name'];


// Récupérer la liste des fichiers dans le répertoire d'alterations, en excluant les scripts déjà présent
$dir = opendir($vyset_dir);
$liste_maj = array();

while($file = readdir($dir))
    if($file != '.' && $file != '..' && !is_dir($vyset_dir.$file) && preg_match("#^[0-9]{8}_[0-9]{2}_.+\.sql$#i", $file))
        if (!in_array($file, $maj_effectue))
            $liste_maj[] = $file;


// Trie les fichiers par ordre alphabetique
sort($liste_maj, SORT_STRING);

// Envoie de la liste des fichiers à lancer
if (!empty($liste_maj))
    echo implode("\n", $liste_maj);

closedir($dir);
mysql_close($link);

?>