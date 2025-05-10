<?php
$host = "127.0.0.1";
$usuario = "root";
$contrasena = "Samhc0880";
$baseDeDatos = "VentadeAutos";

// Crear la conexión
$conexion = new mysqli($host, $usuario, $contrasena, $baseDeDatos);

// Verificar conexión
if ($conexion->connect_error) {
    die("Error en la conexión: " . $conexion->connect_error);
} else {
    echo "¡Conexión exitosa!";
}
?>