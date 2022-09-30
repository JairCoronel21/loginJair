 
 <?php
 
    require_once("../database/config.php");

    $conect = $link; 
    class Usuario{

        private $conect;

        public function __construct()
        {
            $this->conect;
        }


        public function mostrarUsuario ($user){

            global $link;
            $stmt = $link->query("CALL SP_viewUsers('{$user}')");
         //$rs = $this->conect->query("CALL SP_viewUsers('{$user}');");
            $rs = $stmt->fetch_assoc();
         
         return $rs;
        }
    }
 
 ?>