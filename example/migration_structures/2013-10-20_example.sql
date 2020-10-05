CREATE TABLE IF NOT EXISTS `test_migration`
(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

INSERT INTO `test_migration` SET name = CONCAT("Hello World ", CURRENT_TIME);