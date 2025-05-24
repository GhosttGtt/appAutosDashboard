// Archivo JavaScript para gestionar la autenticación de usuarios

// URL base para las peticiones a la API del backend
const API_BASE_URL = '/appAutosDashboard/autozone/api-gestion-autozone/conexion.php';

/**
 * Función principal para procesar el inicio de sesión
 * Realiza la validación y envío de credenciales al servidor
 */
function loginUser() {
    // Obtener los valores ingresados por el usuario
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    // Validación de campos obligatorios
    if (!username || !password) {
        displayErrorMessage("Por favor ingrese usuario y contraseña.");
        return;
    }

    // Petición fetch al servidor para autenticar
    fetch(`${API_BASE_URL}/login`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        // Envío de credenciales en formato JSON
        body: JSON.stringify({ username: username, password: password })
    })
        // Procesamiento de la respuesta del servidor
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al conectar con el servidor.');
            }
            return response.json();
        })
        // Manejo de la respuesta exitosa
        .then(data => {
            if (data.status === 200) {
                // Autenticación exitosa: almacenar token y redirigir
                console.log('Login exitoso', data);
                localStorage.setItem('session_token', data.data.token);
                window.location.href = 'students.html';
            } else {
                // Mostrar mensaje si la autenticación falla
                displayErrorMessage(data.message || "Error desconocido");
            }
        })
        // Captura y manejo de errores de la petición
        .catch(error => {
            console.error("Error:", error);
            displayErrorMessage("Hubo un problema con el inicio de sesión. Intenta de nuevo.");
        });
}

/**
 * Función para mostrar mensajes de error en la interfaz
 * @param {string} message - Mensaje de error a mostrar
 */
function displayErrorMessage(message) {
    const errorMessageElement = document.getElementById('errorMessage');
    errorMessageElement.textContent = message;
    errorMessageElement.style.display = 'block';
}

// Configuración del evento submit del formulario de login
document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevenir el envío tradicional del formulario
    loginUser(); // Llamar a la función de inicio de sesión
});
