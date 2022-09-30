async function getUsuario() {
    try {
        let resp = await fetch("http://localhost/Planilla/controller/persona.php");
        json = await resp.json();
        if (json.status) {
            let data = json.data;


            // let newtr = document.createElement('div');
            let perfilDatos = document.querySelector('#conPerfil');
            // newtr.id = "row_" + data.id;
            perfilDatos.innerHTML = `
                <div class="labelPerfil">
                    <div><h6>NOMBRES</h6><hr/><br/><span>${data.name}</span></div>
                    <div><h6>APELLIDOS</h6><hr/><br/><span>${data.lastname}</span></div>
                </div>
                <div class="labelPerfil">
                    <div><h6>USUARIO</h6><hr/><br/><span>${data.username}</span></div>
                    <div><h6>CORREO</h6><hr/><br/><span>${data.email}</span></div>
                </div >
                <div class="labelPerfil">
                    <div><h6>TELEFONO</h6><hr/><br/><span>${data.telephone}</span></div>
                </div>`;
            document.querySelector('#conPerfil').appendChild(newtr);


        }
        console.log(json);
    } catch (error) {
        console.log("Ocurrio un error: " + error);

    }

}

getUsuario();


// old 
{/* <label for=""><b>Nombres C. </b>${data.name}</label><br>
                        <label for=""><b>Apellidos C. </b> ${data.lastname}</label><br>
                        <label for=""><b>Usuario </b>${data.username}</label><br>
                        <label for=""><b>Correo: </b> ${data.email}</label><br>
                        <label for=""><b>telefono: </b> ${data.telephone}</label><br>
                                                    ${data.option} */}