<?php

   require_once("../models/Usuario.php");
   session_start();
 
   if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
       header("location: login.php");
       exit;
     
      }

      

   $username= $_SESSION["username"];
   // $option = $_REQUEST['op'];
   $option = true;
   $objUsuario = new Usuario();
  
   if ($option) {
      $arrResponse = array('status' => 'false', 'data' => "");
      $arrUsuario = $objUsuario->mostrarUsuario($username);
      //print_r($arrUsuario);
      if(!empty($arrUsuario)){
        
            $iduser = $arrUsuario['id'];
         
           // print_r($iduser);
            $btn = '<a href="http://localhost/Planilla/src/pages/perfil/index.php?p='.$iduser.'">Actualizar Datos</a>';
            $array_option = array('option' =>$btn);
            $arrUsuario =  array_merge($arrUsuario,$array_option);
           // print_r($arrUsuario);
         
         $arrResponse['status'] = 'true';
         $arrResponse['data'] = $arrUsuario;


      }  
     echo json_encode($arrResponse);
     die();
    
   } 
   
  
     
?>