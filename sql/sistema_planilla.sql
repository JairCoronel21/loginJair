-- -----------------------------------
-- BD SISTEMA PLANILLA
-- V. 1.6.
-- -----------------------------------

CREATE DATABASE `sistema_planilla`;
USE `sistema_planilla`;

/* Tabla Rol */
CREATE TABLE `rol` (
 `id` int unsigned primary key auto_increment not null,
 `rol` varchar(50) not null
);

/* Tabla Rol */
CREATE TABLE `typeDoc` (
	`id` int unsigned primary key auto_increment not null,
    `typeDoc` varchar(50) not null
);

/* Tabla Cargos o posiciones */
CREATE TABLE `position` (
 `id` int unsigned primary key auto_increment not null,
 `position` varchar(50) not null
);

/* Tabla Tipo de Banco */
CREATE TABLE `typeBank` (
 `id` int unsigned primary key auto_increment not null,
 `bank` varchar(10)
);

/* Tabla Usuarios */
CREATE TABLE `user` (
 `id` int unsigned primary key auto_increment not null,
 `idRol` int unsigned not null,
 `idTypeDoc` int unsigned not null,
 `numDoc` varchar(20) not null,
 `name` varchar(50) not null,
 `lastName` varchar(50) not null,
 `email` varchar(100) unique not null,
 `birthdate` date not null,
 `username` varchar(100) unique not null,
 `password` blob not null,
 `idPosition` int unsigned not null,
 `image` blob,
 `dateAdmission` date not null,
 `salary` double not null,
 `telephone` varchar(20) not null,
 `idTypeBank` int unsigned not null,
 `bankAccount` varchar(100) not null,
 `status` bool not null,
 INDEX `fk_users_rol` (`idRol` ASC),
 INDEX `fk_users_position` (`idPosition` ASC),
 INDEX `fk_users_typeBank` (`idTypeBank` ASC),
  CONSTRAINT `fk_users_position`
    FOREIGN KEY (`idPosition`)
    REFERENCES `position` (`id`),
  CONSTRAINT `fk_users_rol`
    FOREIGN KEY (`idRol`)
    REFERENCES `rol` (`id`),
  CONSTRAINT `fk_users_typeBank`
    FOREIGN KEY (`idTypeBank`)
    REFERENCES `typebank` (`id`),
  CONSTRAINT `fk_users_typeDoc`
    FOREIGN KEY (`idTypeDoc`)
    REFERENCES `typeDoc` (`id`)
);

/* Tabla Fecha Contrato */
CREATE TABLE `contract` (
 `id` int unsigned primary key auto_increment not null,
 `idUser` int unsigned not null,
 `startContract` date not null,
 `endContract` date not null,
 INDEX `fk_contract_user` (`idUser` ASC),
 CONSTRAINT `fk_contract_user`
    FOREIGN KEY (`idUser`)
    REFERENCES `user` (`id`)
);

/* Lista de asistencia*/
CREATE TABLE `listAssistance` (
 `id` int unsigned primary key auto_increment not null,
 `date` date not null
);
/* Detalle de asistencia */
CREATE TABLE `detailsAssistance` (
 `id` int unsigned primary key auto_increment not null,
 `idListAssistance` int unsigned not null,
 `idUser` int unsigned not null,
 `status` varchar(20) not null,
 `startTime` time,
 `endTime` time,
 INDEX `fk_list_assistance` (`idListAssistance` ASC),
 INDEX `fk_list_user` (`idUser` ASC),
 CONSTRAINT `fk_list_assistance`
    FOREIGN KEY (`idListAssistance`)
    REFERENCES `listAssistance` (`id`),
 CONSTRAINT `fk_list_user`
    FOREIGN KEY (`idUser`)
    REFERENCES `user` (`id`)
);


/************************************************************/
/*				PROCEDIMIENTOS ALMACENADOS					*/
/************************************************************/


DROP FUNCTION IF EXISTS retornador;
DELIMITER $$
CREATE FUNCTION retornador(entrada VARCHAR(200)) RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
  DECLARE salida VARCHAR(200);
  SET salida = entrada;
  RETURN salida;
END $$ 
DELIMITER ;

/* funciona para usuarios Repetidos */
drop function if exists getCod;
DELIMITER $$
create function getCod(nom char(30), ape char(30))
returns char(10)
DETERMINISTIC
begin
    declare cod char(10);
    declare token char(5);

    set nom = trim(substring(nom, 1,3));
    set ape = trim(substring(ape, 1,3));
    set cod = trim(concat(nom,ape));

    if exists (select `username` from `user`  where `username` = cod order by `username` asc limit 1) then
        set token = (SELECT (round((RAND() * (10 - 1)) + 1)));
        set ape = trim(substring(ape, 1,3));
        set cod = concat(nom,ape,token);
        return (cod);
    else
        set cod = cod;
        return (cod);
    end if;

end $$
DELIMITER ;

/* SP Crear Usuario */
DROP procedure IF exists `SP_createUser`;
DELIMITER $$
CREATE PROCEDURE `SP_createUser`
(IN `@idTypeDoc` int,
IN `@numDoc` varchar(20), 
IN `@name` varchar(50), 
IN `@lastName` varchar(50), 
IN `@email` varchar(100), 
IN `@birthdate` date, 
IN `@password` blob, 
IN `@idPosition` int, 
IN `@salary` double, 
IN `@telephone` varchar(20), 
IN `@idTypeBank` int, 
IN `@bankAccount` varchar(100),
OUT `@texto` VARCHAR(100)
)
BEGIN
	DECLARE `existe_persona` INT;
    DECLARE `llave` varchar(128);
    DECLARE `id` INT;
	DECLARE `newUsername` VARCHAR(100);
    IF EXISTS (SELECT * FROM USER WHERE email =`@email`) then
		BEGIN
		set `@texto`='Correo ya existente' ;
		select retornador(`@texto`) AS ajax;
       END;
	ELSEIF EXISTS (SELECT * FROM USER WHERE numDoc =`@numDoc`) then
		BEGIN
		set  `@texto`='Numero de documento ya existente' ;
       select retornador(`@texto`) AS ajax;
        END;
	ELSEIF EXISTS (SELECT * FROM USER WHERE bankAccount =`@bankAccount`) then
		BEGIN
		set  `@texto`='Numero de cuenta bancaria existente' ;
       select retornador(`@texto`) AS ajax;
        END;
	else 
    set existe_persona = 0;
	 END IF;
   SET `llave` = 'xyz123';
   IF existe_persona = 0 then
		SET `newUsername` = getcod(`@name`,`@lastName`);
		INSERT INTO `user`(`idRol`,`idTypeDoc`,`numDoc`,`name`,`lastName`,`email`,`birthdate`,`username`,`password`,`idPosition`,`dateAdmission`,`salary`,`telephone`,`idTypeBank`,`bankAccount`,`status`) VALUES(2,`@idTypeDoc`,`@numDoc`,`@name`,`@lastName`,`@email`,`@birthdate`,`newUsername`,aes_encrypt(`@password`,`llave`),`@idPosition`,CURDATE(),`@salary`,`@telephone`,`@idTypeBank`,`@bankAccount`,true);
		SET `id`= LAST_INSERT_ID();
  else
	set  id=0;
   END IF;
	select id;
END$$
DELIMITER ;
/* SP Crear Usuario OLD 
DELIMITER $$
CREATE PROCEDURE `SP_createUser`(IN `@idTypeDoc` INT, IN `@numDoc` varchar(20), IN `@name` varchar(50), IN `@lastName` varchar(50), IN `@email` varchar(100), IN `@birthdate` date, IN `@password` blob, IN `@idPosition` int, IN `@salary` double, IN `@telephone` varchar(20), IN `@idTypeBank` int, IN `@bankAccount` varchar(100))
BEGIN
	DECLARE `existe_persona` INT;
    DECLARE `existe_user` INT;
    DECLARE `llave` varchar(128);
    DECLARE `id` INT;
	DECLARE `newUsername` VARCHAR(100);
    DECLARE `string1` VARCHAR(1);
    DECLARE `string2` VARCHAR(45);
    DECLARE `string3` VARCHAR(1);
    DECLARE `string4` VARCHAR(3);
    DECLARE `position` INT;
    SET `llave` = 'xyz123';
    SET `existe_persona` = (SELECT count(*) FROM `user` WHERE `email` = `@email` LIMIT 1);
    IF `existe_persona` = 0 THEN
        SET `position` = INSTR(`@lastName`," ");
		SET `string1` = LEFT(`@name`,1);
		SET `string2` = SUBSTRING_INDEX(`@lastName`, " ", 1);
		SET `string3` = LEFT(substr(`@lastName`,`position`+1),1);
        SET `string4` = RIGHT(`@numDoc`,3);
		SET `newUsername` = LOWER(CONCAT(`string1`,`string2`,`string3`,`string4`));
        SET `existe_user` = (SELECT count(*) FROM `user` WHERE `username` = `newUsername` LIMIT 1);
        IF `existe_user` = 0 THEN
			INSERT INTO `user`(`idRol`,`idTypeDoc`,`numDoc`,`name`,`lastName`,`email`,`birthdate`,`username`,`password`,`idPosition`,`dateAdmission`,`salary`,`telephone`,`idTypeBank`,`bankAccount`,`status`) VALUES(2,`@idTypeDoc`,`@numDoc`,`@name`,`@lastName`,`@email`,`@birthdate`,`newUsername`,aes_encrypt(`@password`,`llave`),`@idPosition`,CURDATE(),`@salary`,`@telephone`,`@idTypeBank`,`@bankAccount`,true);
			SET `id`= LAST_INSERT_ID();
        ELSE
			SET `id` = 0;
		END IF;
   ELSE
        SET `id` = 0;
   END IF;
        SELECT `id`;
END$$
DELIMITER ; */


/* SP Login - Validacion de credenciales */
DELIMITER $$
CREATE PROCEDURE `SP_Login`(IN `@userOrEmail` varchar(50), IN `@pass` varchar(50))
BEGIN
	DECLARE `llave` varchar(128);
    DECLARE `validate` bool;
    DECLARE `idUser` int;
    DECLARE `rol` int;
	SET `llave` = 'xyz123';
	IF exists(SELECT * FROM `user` WHERE `username`=`@userOrEmail` AND `password`=aes_encrypt(`@pass`,`llave`) OR `email`= `@userOrEmail` AND `password`=aes_encrypt(`@pass`,`llave`)) THEN
		SET `validate` = TRUE;
        SET `idUser` = (SELECT `id` FROM `user` WHERE `username`=`@userOrEmail` OR `email`= `@userOrEmail`);
        SET `rol` = (SELECT `idRol` FROM `user` WHERE `username`=`@userOrEmail` OR `email`= `@userOrEmail`);
    ELSE
		SET `validate` = FALSE;
	END IF;
    SELECT `validate` as credentials,`idUser`,`rol`;
END$$
DELIMITER ;

/* SP Cambiar contraseña */
DELIMITER $$
CREATE PROCEDURE `SP_ResetPassword`(IN `@newPassword` VARCHAR(100), IN `@idUser` INT)
BEGIN
	DECLARE `llave` varchar(128);
	SET `llave` = 'xyz123';
	UPDATE `user` SET `password` = aes_encrypt(`@newPassword`,`llave`) WHERE id = `@idUser`;
END$$
DELIMITER ;

/* Procedimiento almacenado */
DELIMITER $$
CREATE PROCEDURE `SP_userYear`(IN `@idUser` INT)
BEGIN
	DECLARE `years` int;
    DECLARE `newBirthdate` DATE;
	SET `newBirthdate` = (SELECT `birthdate` FROM `user` WHERE `id`=`@idUser`);
    SET `years` = YEAR(CURDATE())-YEAR(`newBirthdate`);
	SELECT `years`;
END$$
DELIMITER ;

/* SP Mostrar Usuarios */
drop procedure if exists  `SP_viewUsers`;
DELIMITER $$
CREATE PROCEDURE `SP_viewUsers`(in `@username` varchar(100) )
BEGIN
	SELECT id, `name`, lastname , email, username, telephone  FROM `user` where `username` = `@username`;
END$$
DELIMITER ;
/* SP Mostrar Usuarios OLD 
DELIMITER $$
CREATE PROCEDURE `SP_viewUsers`()
BEGIN
	SELECT `user`.`id`,`rol`.`rol`,`typeDoc`.`typeDoc`,`user`.`numDoc`,`user`.`name`,`user`.`lastName`,`user`.`email`,`user`.`birthdate`,`user`.`username`,`position`.`position`,`user`.`dateAdmission`,`user`.`salary`,`user`.`telephone`,`typeBank`.`bank`,`user`.`bankAccount` FROM `user` 
		INNER JOIN `rol` ON `user`.`idRol` = `rol`.`id`
        INNER JOIN `typeDoc` ON `user`.`idTypeDoc` = `typeDoc`.`id`
        INNER JOIN `position` ON `user`.`idPosition` = `position`.`id`
        INNER JOIN `typeBank` ON `user`.`idTypeBank` = `typeBank`.`id`
        WHERE `user`.`idRol` = 2;
END$$
DELIMITER ; */

/* SP Buscar usuario por ID */
DELIMITER $$
CREATE PROCEDURE `SP_findUserbyId`(IN `@idUser` int)
BEGIN
SELECT * FROM `user` WHERE `id` = `@idUser`;
END$$
DELIMITER ;

/* SP Eliminar usuario por ID */
DELIMITER $$
CREATE PROCEDURE `SP_deleteUser` (in `@idUser` int)
BEGIN
	DELETE FROM `user` WHERE `id` = `@idUser`;
END$$
DELIMITER ;

/* SP Actualizar usuario por ID */
DELIMITER $$
CREATE PROCEDURE `SP_updateById` (IN `@idTypeDoc` INT, IN `@numDoc` varchar(20), IN `@name` varchar(50), IN `@lastName` varchar(50), IN `@birthdate` date, IN `@idPosition` int, IN `@image` BLOB,IN `@salary` DOUBLE, IN `@telephone` VARCHAR(20), IN `@idTypeBank` INT, IN `@bankAccount` VARCHAR(100),IN `@idUser` INT)
BEGIN
	UPDATE `user` SET 
		`idTypeDoc` = `@idTypeDoc`,
        `numDoc` = `@numDoc`,
        `name` = `@name`,
        `lastName` = `@lastName`,
        `birthdate` = `@birthdate`,
        `idPosition` = `@idPosition`,
        `image` = `@image`,
        `salary` = `@salary`,
        `telephone` = `@telephone`,
        `idTypeBank` = `@idTypeBank`,
        `bankAccount` = `@bankAccount`
    WHERE id = `@idUser`;
END $$
DELIMITER ;

/*		Contar los datos asistencias 	*/
DELIMITER $$
CREATE PROCEDURE `SP_CountAsistance` (IN `@idUser` INT)
BEGIN
	DECLARE `fechaActual` varchar(2);
	SET `fechaActual` = (SELECT DATE_FORMAT(CURDATE(), "%m"));
	SELECT COUNT(*) AS totalRegistro FROM detailsAssistance AS `d`
		INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
        WHERE `d`.`idUser`= `@idUser` AND `l`.`date` LIKE CONCAT('%-',`fechaActual`,'-%');
END $$
DELIMITER ;

/*		pagina de lista asistencias 	*/
DELIMITER $$
CREATE PROCEDURE `SP_PagAsistance` (IN `@idUser` INT, IN `@desde` INT, IN `@porPagina` INT)
BEGIN
	DECLARE `fechaActual` varchar(2);
	SET `fechaActual` = (SELECT DATE_FORMAT(CURDATE(), "%m"));
	SELECT `d`.`id`,`l`.`date`,`d`.`startTime`,`d`.`endTime`,`d`.`status` FROM `detailsAssistance` AS `d` 
    INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
    WHERE `d`.`idUser`= `@idUser` AND `l`.`date` LIKE CONCAT('%-',`fechaActual`,'-%') LIMIT `@desde`,`@porPagina`;
END $$
DELIMITER ;

/*		buscar de lista asistencias 	*/
DELIMITER $$
CREATE PROCEDURE `SP_FindAssistance` (IN `@idUser` INT, IN `@mes` VARCHAR(15), IN `@periodo` VARCHAR(15), IN `@desde` INT,IN `@porPagina` INT)
BEGIN
	SELECT `d`.`id`,`l`.`date`,`d`.`startTime`,`d`.`endTime`,`d`.`status` FROM `detailsAssistance` AS `d` 
    INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
    WHERE `d`.`idUser`= `@idUser` AND `l`.`date` LIKE CONCAT('%-',`@mes`,'-%') LIMIT `@desde`,`@porPagina`;
END $$
DELIMITER ;

/*	numero de asistencias	*/
DELIMITER $$
CREATE PROCEDURE `SP_NumAsistencia` (IN `@idUser` INT)
BEGIN
	DECLARE `fechaActual` varchar(2);
    DECLARE `asistio` varchar(10);
    DECLARE `justificado` varchar(10);
    DECLARE `falto` varchar(10);
	SET `fechaActual` = (SELECT DATE_FORMAT(CURDATE(), "%m"));
	SET `asistio` = (SELECT count(`status`) FROM `detailsAssistance` AS `d` 
	INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
	WHERE `d`.`idUser`= `@idUser` AND `status`= "ASISTIO" AND `l`.`date` LIKE CONCAT('%-',`fechaActual`,'-%'));
    SET `justificado` = (SELECT count(`status`) FROM `detailsAssistance` AS `d` 
	INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
	WHERE `d`.`idUser`= `@idUser` AND `status`= "JUSTIFICADO" AND `l`.`date` LIKE CONCAT('%-',`fechaActual`,'-%'));
    SET `falto` = (SELECT count(`status`) FROM `detailsAssistance` AS `d` 
	INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id` 
	WHERE `d`.`idUser`= `@idUser` AND `status`= "FALTO" AND `l`.`date` LIKE CONCAT('%-',`fechaActual`,'-%'));
    
    SELECT asistio,justificado,falto;
END $$
DELIMITER ;
