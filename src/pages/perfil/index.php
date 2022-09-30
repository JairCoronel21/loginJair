<?php
session_start();

$arrayIncident = array();

if (!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    header("location: ../auth/login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil</title>
    <link rel="stylesheet" href="../../css/sidemenu.css">
    <link rel="stylesheet" href="../../css/styleform.css">
    <link rel="stylesheet" href="../../css/newEstilo.css">
</head>

<body>
    <?php
    include_once("../../../database/config.php");
    include_once("../../../controller/funcs.php");
    include_once("../../layouts/header.php");
    ?>

    <!-- <div class="modal">
        <div class="bodyModal">

        </div>
    </div> -->

    <div id="main-container">
        <div class="headerContainer">
            <h2>PERFIL DEL USUARIO</h2>
            <p>Datos personales del usuario</p>
        </div>
        <div class="bodyContainer">
            <div class="headerCard">
                <div class="perfilCard">
                    <div class="imgPerfil">
                        <img src="../../public/img/perfil.jpg" width="200" alt="">
                        <br />
                        <input type="file" name="" id="">
                    </div>
                    <div class="bodyPerfil" id="conPerfil">
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="../../js/vista_usuario.js"></script>

</html>