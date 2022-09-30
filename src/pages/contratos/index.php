<?php
session_start();

$arrayIncident = array();

if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: ../auth/login.php");
    exit;
}
// echo date("m")
//$meses = [["Enero","01"],["Febrero"],["Marzo"],["Abril"],["Mayo"],["Junio"],"Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
$meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];

function clearStoredResults(){
    global $mysqli;
    
    do {
         if ($res = $mysqli->store_result()) {
           $res->free();
         }
    } while ($mysqli->more_results() && $mysqli->next_result());        
    
}

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contratos</title>
    <link rel="stylesheet" href="../../css/sidemenu.css">
    <link rel="stylesheet" href="../../css/estilos.css">
    <link rel="stylesheet" href="../../css/newEstilo.css">

</head>

<body>
    <?php
    // dirname(__FILE__).'/functions.php'
    include_once("../../../database/config.php");
    include_once("../../../controller/funcs.php");
    $totalRegister = countPag($_SESSION["id"]);
    
    $porPagina = 5;

    if (empty($_GET['pagina'])) {
        $pagina = 1;
    } else {
        $pagina = $_GET['pagina'];
    }

    $desde = ($pagina - 1) * $porPagina;
    $totalPagina = ceil($totalRegister / $porPagina);

    if(isset($_GET['mes']) && isset($_GET['periodo'])) {
        $mes = $_GET['mes'];
        $periodo = $_GET['periodo'];
    
        $arrayListAsistance = findAssistance($_SESSION['id'],$mes,$periodo,$desde,$porPagina);
    }else {
    $arrayListAsistance = pagAsistance($_SESSION["id"],$desde,$porPagina);
    }
    
    $arrayIncident = returnIncident($_SESSION["id"]);
    
    include_once("../../layouts/header.php");

    ?>

    <div id="main-container">
        <div class="headerContainer">
            <h2>CONTROL DE ASISTENCIA</h2>
            <p>Verifica tu asistencia en el trabajo</p>
        </div>
        <!-- Tabla -->
        <div class="bodyContainer">
            <div class="headerCard">
                <div class="first">
                    <?php 
                        foreach ($arrayIncident as $data) { ?>
                            <div>
                                <div>Asistio</div>
                                <div><?php echo $data["asistio"] ?></div>
                            </div>
                            <div>
                                <div>Falto</div>
                                <div><?php echo $data["falto"] ?></div>
                            </div>
                            <div>
                                <div>Justificado</div>
                                <div><?php echo $data["justificado"] ?></div>
                            </div>
                    <?php } ?>
                </div>
                <div class="second">
                    <form method="GET">
                    <label for="mes">Fecha</label>
                    <select name="mes" id="mes" class="selectInput">
                        <?php for ($i=0; $i < count($meses); $i++) {  ?>
                            <option value="<?php echo date("m",mktime(0,0,0,$i+1)) ?>"><?php echo $meses[$i] ?></option>
                        <?php }?>
                    </select>
                    <label for="periodo">Periodo</label>
                    <select name="periodo" id="periodo" class="selectInput">
                        <option value="1">2020</option>
                        <option value="2">2021</option>
                        <option value="3">2022</option>
                    </select>
                    <button class="bg-blue-500 hover:bg-blue-400 rounded-md text-white px-3 py-2">Buscar</button>
                    </form>
                </div>
            </div>

            <hr />
            <!-- tabla -->
            <div class="bodyCard">
                <?php
                if (count($arrayListAsistance) > 0) { ?>
                    <table>
                        <thead>
                            <tr>
                                <th scope="col">
                                    ID
                                </th>
                                <th scope="col">
                                    Fecha
                                </th>
                                <th scope="col">
                                    Inicio
                                </th>
                                <th scope="col">
                                    Fin
                                </th>
                                <th scope="col">
                                    Incidencia
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            foreach ($arrayListAsistance as $data) {
                                
                            ?>
                                <tr>
                                    <td>
                                        <?php echo $data["id"] ?>
                                    </td>
                                    <td>
                                        <?php echo $data["date"] ?>
                                    </td>
                                    <td>
                                        <?php echo $data["startTime"] ?>
                                    </td>
                                    <td>
                                        <?php echo $data["endTime"] ?>
                                    </td>
                                    <td>
                                        <div class="notif <?php switch ($data["status"]) {
                                            case 'ASISTIO':
                                                echo "green";
                                                break;
                                            case 'FALTO':
                                                echo "red";
                                                break;
                                            case 'JUSTIFICADO':
                                                echo "orange";
                                                break;
                                            default:
                                                echo "green";
                                                break;
                                        } ?>">
                                            <?php echo $data['status'] ?>
                                        </div>
                                    </td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                <?php

                } else { ?>
                    <div class="nullContentCard">No hay contenido</div>
                <?php } ?>
            </div>

            <div class="paginador">
                <div class="paginadorMovil">
                    <?php
                    if ($pagina != 1) {
                    ?>
                        <a href="?pagina=<?php echo $pagina - 1 ?>">Atrás</a>
                    <?php }
                    if ($pagina != $totalPagina) {
                    ?>
                        <a href="?pagina=<?php echo $pagina + 1 ?>">Siguiente</a>
                    <?php } ?>
                </div>
                <div class="paginadorEscritorio">
                    <div>
                        <p>
                            Mostrando
                            <span>1</span>
                            a
                            <span><?php echo $porPagina ?></span>
                            de
                            <span><?php echo $totalRegister ?></span>
                            resultados
                        </p>
                    </div>
                    <div>
                        <nav class="navPagi" aria-label="Pagination">

                            <?php
                            if ($pagina != 1) {
                            ?>
                                <a href="?pagina=<?php echo $pagina - 1 ?>" class="btnExt">
                                    <span>Atrás</span>
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd" />
                                    </svg>
                                </a>

                            <?php
                            }
                            for ($i = 1; $i <= $totalPagina; $i++) {
                                if ($i == $pagina) {
                                    echo '<a href="?pagina=' . $i . '" class="selected">' . $i . '</a>';
                                } else {
                                    echo '<a href="?pagina=' . $i . '" class="btnInt">' . $i . '</a>';
                                }
                            }

                            if ($pagina != $totalPagina) {
                            ?>

                                <a href="?pagina=<?php echo $pagina + 1 ?>" class="btnExt">
                                    <span>Siguiente</span>
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                        <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
                                    </svg>
                                </a>
                            <?php } ?>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>