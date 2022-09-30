<?php 
    // $ruta = $_SERVER['DOCUMENT_ROOT'].'/PRUEBA-DOS/logout.php';
    // echo $ruta;
?>
<div id="sidemenu" class="menu-collapsed">

    <!--HEADER -->
    <div id="header">
        <div id="title">
            <span> Sistema de planilla </span>
        </div>
        <div id="menu-btn">
            <div class="btn-hamburger"> </div>
            <div class="btn-hamburger"> </div>
            <div class="btn-hamburger"> </div>
            <div class="btn-hamburger"> </div>
        </div>
    </div>

    <!--PERFIL -->
    <div id="perfil">
        <div id="foto">
            <img src="/Planilla/src/public/img/perfil.jpg" alt="">
        </div>
        <div id="name">
            <span> <?php echo $_SESSION["username"] ?> </span> 
        </div>
    </div>

    <!--ITEMS -->

    <div id="menu-items">

        <div class="item">
            <a href="inicio.php">
                <div class="icon">
                    <img src="/Planilla/src/public/img/inicio.jpeg" alt=""> 
                </div>
                <div class="title"> 
                    <span> Inicio </span> 
                </div>
            </a>
        </div>

        <div class="item separator"></div>

        <div class="item">
            <a href="/Planilla/src/pages/perfil/index.php">
                <div class="icon"><img src="/Planilla/src/public/img/perfil1.png" alt=""> </div>
                <div class="title"> <span> Perfil </span> </div>
            </a>
        </div>

        <div class="item">
            <a href="/Planilla/src/pages/asistencia/index.php">
                <div class="icon"><img src="/Planilla/src/public/img/asistencia.png" alt=""> </div>
                <div class="title"> <span> Asistencia </span> </div>
            </a>
        </div>

        <div class="item">
            <a href="/Planilla/src/pages/auth/logout.php">
                <div class="icon"><img src="/Planilla/src/public/img/cerrarsesion.png" alt=""> </div>
                <div class="title"> <span> Cerrar sesión </span> </div>
            </a>
        </div>

        <div class="item">
            <a href="#">
                <div class="icon"><img src="/Planilla/src/public/img/privacidad.png" alt=""> </div>
                <div class="title"> <span> Privacidad </span> </div>
            </a>
        </div>

    </div>
</div>


<script>
    const btn = document.querySelector('#menu-btn');
    const menu = document.querySelector('#sidemenu');
    btn.addEventListener('click', e => {
        menu.classList.toggle("menu-expanded");
        menu.classList.toggle("menu-collapsed");

        document.querySelector('body').classList.toggle('body-expanded');
    });
</script>