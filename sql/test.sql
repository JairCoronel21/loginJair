USE `sistema_planilla`;

/* Testeo */
INSERT INTO `rol` VALUES (null,'admin'),(null,'user'),(null,'support');
INSERT INTO `typeDoc` VALUES (null,'DNI'),(null,'CARNET DE EXTRANJERIA'),(null,'PASAPORTE'),(null,'P. NAC.');
INSERT INTO `position` VALUES (null,'apoyo administrativo'),(null,'asesor'),(null,'operario');
INSERT INTO `typeBank` VALUES (null,'BCP'),(null,'Interbank'),(null,'Scotiabank');

/* se encripto con aes_encrypt */
INSERT INTO `user` VALUES (null,1,1,'example','example','example','example@gmail.com','2002-06-30','example',aes_encrypt('123456','xyz123'),1,null,'2022-08-16',600.00,'example',1,'example',true),
						 (null,2,1,'example2','example2','example2','example2@gmail.com','2002-06-30','example2',aes_encrypt('12345','xyz123'),1,null,'2022-08-16',600.00,'example2',1,'example2',true);
INSERT INTO `listAssistance` VALUES (null,'2022-09-14'),
					(null,'2022-09-15'),
                    (null,'2022-09-16'),
                    (null,'2022-09-17');
INSERT INTO `detailsAssistance` VALUES (null,1,2,'ASISTIO','08:00','17:00'),
									(null,2,2,'FALTO','08:00','17:00'),
                                    (null,3,2,'JUSTIFICADO','08:00','17:00'),
                                    (null,4,2,'ASISTIO','08:00','17:00');

/* Ver registros y comandos */
SELECT * FROM `rol`;
SELECT * FROM `position`;
SELECT * FROM `listAssistance`;
SELECT * FROM `detailsAssistance`;
SELECT * FROM `typeDoc`;
SELECT * FROM `typeBank`;
SELECT * FROM `user`;
SELECT cast(aes_decrypt(`password`, 'xyz123') AS char) AS 'password' FROM `user`;
SELECT YEAR(CURDATE())-YEAR(`birthdate`)  AS 'Edad Actual' FROM `user`;
/* SELECT userYear(`birthdate`) AS 'years' FROM `user` WHERE `id` = 1; */
SELECT `user`.`id`,`rol`.`rol`,`typeDoc`.`typeDoc`,`user`.`numDoc`,`user`.`name`,`user`.`lastName`,`user`.`email`,`user`.`birthdate`,`user`.`username`,`position`.`position`,`user`.`dateAdmission`,`user`.`salary`,`user`.`telephone`,`typeBank`.`bank`,`user`.`bankAccount` FROM `user` 
		INNER JOIN `rol` ON `user`.`idRol` = `rol`.`id`
        INNER JOIN `typeDoc` ON `user`.`idTypeDoc` = `typeDoc`.`id`
        INNER JOIN `position` ON `user`.`idPosition` = `position`.`id`
        INNER JOIN `typeBank` ON `user`.`idTypeBank` = `typeBank`.`id`;
/* Eliminacion de tablas y DB */
DROP TABLE `user`;
DROP TABLE `position`;
DROP TABLE `listAssistance`;
DROP DATABASE `sistema_planilla`;

/* Eliminar registros */
DELETE FROM `user` where `id`=1;
DELETE FROM `listAssistance`;
/* Procedimientos almacenados */
CALL SP_createUser(1,'numDoc3','Elizabeth','Arbieto Collahua','1235467@gmail.com','2002-06-30','123456',1,600.00,'example3',1,'example3',@texto);
CALL SP_createUser(1,'74823803','Ronaldo Basilio','Enciso Luque','ronaldoencisoluque@gmail.com','2002-06-30','456789',1,6000.00,'example4',1,'example4',@texto);
CALL SP_viewUsers();
CALL SP_findUserbyId(1);
CALL SP_deleteUser(3);
CALL SP_userYear(1);
CALL SP_Login("example2","456875");
CALL SP_Login("example2@gmail.com","4568754");
CALL SP_Login('example','rtodsgp');
CALL SP_ResetPassword('959798934','1');
CALL SP_countAsistance(2);
CALL SP_PagAsistance(2,0,5);
CALL SP_NumAsistencia(2);
CALL SP_FindAssistance(2,'10','2022',0,4);

/* Funciones */
SELECT NOW();
SELECT MONTH(CURDATE()) as `Mes`;
SELECT DATE_FORMAT(CURDATE(), "%m");

SELECT `d`.`id`,`l`.`date`,`d`.`startTime`,`d`.`endTime`,`d`.`status` FROM `detailsAssistance` AS `d` 
		INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id`;
SELECT `d`.`id`,`l`.`date` FROM `detailsAssistance` AS `d`
		INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id`
WHERE `d`.`idUser`= 2 AND `l`.`date` LIKE CONCAT('%-','09','-%');
SELECT COUNT(*) FROM detailsAssistance AS `d`
		INNER JOIN `listAssistance` AS `l` ON `d`.`idListAssistance` = `l`.`id`
WHERE `d`.`idUser`= 2 AND `l`.`date` LIKE CONCAT('%-','09','-%');