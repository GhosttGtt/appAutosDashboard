<?php
// Parámetros de conexión a la base de datos
$host = '127.0.0.1';    // Nombre del servidor MySQL
$db = 'uspg';          // Nombre de la base de datos
$user = 'root';        // Usuario de MySQL
$pass = '';            // Contraseña de MySQL (vacía para instalación por defecto)

// Hacer la variable de conexión disponible globalmente
global $conn;

try {
    // Crear nueva conexión a la base de datos MySQL
    $conn = new mysqli($host, $user, $pass, $db);
    
    // Verificar si la conexión fue exitosa
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    
    // Establecer la codificación de caracteres a UTF-8
    $conn->set_charset("utf8mb4");
    
} catch (Exception $e) {
    // Manejar errores de conexión a la base de datos
    header('Content-Type: application/json');
    http_response_code(500);    // Establecer código de respuesta HTTP a 500 (Error del Servidor)
    
    // Devolver mensaje de error en formato JSON
    echo json_encode([
        'status' => 500,
        'message' => 'Database connection error',
        'error' => $e->getMessage()
    ]);
    exit;
}
?>
