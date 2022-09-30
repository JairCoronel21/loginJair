<?php


require_once '../../../database/config.php';
require_once '../../../controller/funcs.php';


$errors = array();


if (!empty($_POST)) {



	$email = $link->real_escape_string($_POST['email']);

	if (!isEmail($email)) {
		$errors[] = "Debe ingresar un correo electronico valido";
	}


	if (emailExiste($email)) {

		$user_id = getValor('id', 'email', $email);
		$nombre = getValor('name', 'email', $email);


		$url = 'http://' . $_SERVER["SERVER_NAME"] .
			'/Planilla/src/pages/auth/reset-password.php?user_id=' . $user_id;

		$asunto = 'Recuperar Password - Sistema de Usuarios';
		$cuerpo = "Hola $nombre: <br /><br />Se ha solicitado 
                un reinicio de contrase&ntilde;a. <br/><br/>Para restaurar la
                contrase&ntilde;a, visita la siguiente direcci&oacute;n: <a href='$url'>Cambiar Password</a>";

		if (enviarEmail($email, $nombre, $asunto, $cuerpo)) {

			echo "Hemos enviado un correo electronico a la direccion 
                     $email para restablecer tu password.<br />";
			echo "<a href='login.php'>Iniciar Sesion</a>";
			exit;
		} else {
			$errors[] = "Error al enviar el email";
		}
	} else {
		$errors[] = "No existe el correo electronico";
	}
}




?>

<!doctype html>
<html lang="es">

<head>
	<link href="/Planilla/src/css/estilo.css" rel="stylesheet" type="text/css">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Recuperar Password</title>

	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<script src="js/bootstrap.min.js"></script>

</head>

<body>
	<header class="izquierda">
		<h1>Softgold</h1>
		<p class="slogan">Cero preocupaciones con Softgold.</p>
	</header>
	<section class="container">
		<h2>Recuperar Password</h2>
		<p class="login-text">Para recuperar su contraseña, porfavor indiquenos a que mail podemos contactarlo</p>
		<div id="loginbox" style="margin-top:50px;" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
			<div class="panel panel-info">
				<div class="panel-heading">
					<div style="float:right; font-size: 80%; position: relative; left: -320px; top:-10px"><a class="a1" href="login.php">Iniciar Sesi&oacute;n</a></div>
				</div>

				<div style="padding-top:30px" class="panel-body">

					<div style="display:none" id="login-alert" class="alert alert-danger col-sm-12"></div>

					<form id="loginform" class="form-horizontal" role="form" action="<?php $_SERVER['PHP_SELF'] ?>" method="POST" autocomplete="off">

						<div style="margin-bottom: 25px" class="input-group">
							<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
							<input id="email" type="email" class="inputValue" name="email" placeholder="email" required>
						</div>

						<div style="margin-top:10px" class="form-group">
							<div class="form-group">
								<!-- El boton Ingresar -->
								<section class="container">

									<button>
										<div>Recuperar</div>
									</button>

								</section>
							</div>
						</div>
					</form>
					<div class="underlay-photo">
						<img src="../../public/img/olas.png">
					</div>
					<div class="underlay-black"></div>
					<?php echo resultBlock($errors); ?>
				</div>
			</div>
		</div>
	</section>
</body>

</html>