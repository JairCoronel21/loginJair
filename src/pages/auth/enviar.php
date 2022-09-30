<?php
    require_once ("../../../PHPMailer/clsMail.php");

    $mailSend = new clsMail();

    $url = 'http://'.$_SERVER["SERVER_NAME"].'/Planilla/src/pages/auth/reset-password.php?user_id='.$user_id;

    $bodyHTML = "
    Hola usuario querido: <br /><br />Se ha solicitado 
    un reinicio de contrase&ntilde;a. <br/><br/>Para restaurar la
    contrase&ntilde;a, visita la siguiente direcci&oacute;n: <a href='$url'>Cambiar Password</a>";
    
    $enviado =  $mailSend->metEnviar("Youtube.com.mx","Correos Youtube","jilmercoronel.16@gmail.com","Asunto X", $bodyHTML);

    if($enviado){
        echo ("Enviado");
    }else {
        echo ("No se pudo enviar el correo");
    }

?>