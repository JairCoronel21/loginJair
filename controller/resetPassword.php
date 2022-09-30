
<?php

function resetPassword($link, $new_password) {
   $sql = "CALL SP_ResetPassword(?,?)";

        if($stmt = mysqli_prepare($link, $sql)){
            
            mysqli_stmt_bind_param($stmt, "si", $param_password, $param_id);
            
            
            $param_password = $new_password;
            $param_id = $_SESSION["id"];
            
            //Ejeccutar el statement
            if(mysqli_stmt_execute($stmt)){
               
                session_destroy();
                header("location: login.php");
                exit();
            } else{
                echo "Algo salió mal, por favor vuelva a intentarlo.";
            }
        }
        
        
        mysqli_stmt_close($stmt);
}
?>