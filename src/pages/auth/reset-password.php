<?php
/*
session_start();
 

if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: login.php");
    exit;
}
*/

require_once '../../../database/config.php';


$new_password = $confirm_password = "";
$new_password_err = $confirm_password_err = "";


if ($_SERVER["REQUEST_METHOD"] == "POST") {


    if (empty(trim($_POST["new_password"]))) {
        $new_password_err = "Please enter the new password.";
    } elseif (strlen(trim($_POST["new_password"])) < 6) {
        $new_password_err = "La contraseña al menos debe tener 6 caracteres.";
    } else {
        $new_password = trim($_POST["new_password"]);
    }


    if (empty(trim($_POST["confirm_password"]))) {
        $confirm_password_err = "Por favor confirme la contraseña.";
    } else {
        $confirm_password = trim($_POST["confirm_password"]);
        if (empty($new_password_err) && ($new_password != $confirm_password)) {
            $confirm_password_err = "Las contraseñas no coinciden.";
        }
    }


    if (empty($new_password_err) && empty($confirm_password_err)) {

        $sql = "CALL SP_ResetPassword(?,?)";

        if ($stmt = mysqli_prepare($link, $sql)) {

            mysqli_stmt_bind_param($stmt, "si", $param_password, $param_id);


            $param_password = $new_password;
            $param_id = $_SESSION["id"];

            //Ejeccutar el statement
            if (mysqli_stmt_execute($stmt)) {

                session_destroy();
                header("location: login.php");
                exit();
            } else {
                echo "Algo salió mal, por favor vuelva a intentarlo.";
            }
        }


        mysqli_stmt_close($stmt);
    }


    mysqli_close($link);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>

    <link href="/Planilla/src/css/estilo.css" rel="stylesheet" type="text/css">
    <meta charset="UTF-8">
    <title>Cambia tu contraseña acá</title>

    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximun-scale=1.0, minimal-scale=1.0">
</head>

<body>
    <header class="izquierda">
        <h1>Softgold</h1>
        <p class="slogan">Cero preocupaciones con Softgold.</p>
    </header>
    <section class="container">


        <h2>Cambiar Contraseña</h2>
        <div>
            <b>
                <p class="p1">Complete este formulario para restablecer su contraseña.</p>
            </b>
            <b>
                <p class="p2">Sugerimos que la siguiente sea una contraseña fácil de recordar para usted.</p>
            </b><br>
        </div>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <div class="form-group <?php echo (!empty($new_password_err)) ? 'has-error' : ''; ?>">
                <b><label class="p1">Nueva contraseña</label></b>
                <input type="password" name="new_password" class="inputValue" value="<?php echo $new_password; ?>">
                <span class="help-block"><?php echo $new_password_err; ?></span>
            </div>
            <div class="form-group <?php echo (!empty($confirm_password_err)) ? 'has-error' : ''; ?>">

                <b><label class="p1">Confirmar contraseña</label></b>
                <input type="password" name="confirm_password" class="inputValue">

                <span class="help-block"><?php echo $confirm_password_err; ?></span>
            </div>
            <div class="form-group">
                <section class="container">

                    <button>
                        <div>Cambiar</div>
                    </button>

                </section>
                <b><a class="p1" href="login.php">Cancelar</a></b>
            </div>
        </form>
        <div class="underlay-photo">
            <img src="../../public/img/olas.png">
        </div>
        <div class="underlay-black"></div>
    </section>


</body>

</html>