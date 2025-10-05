// server.js

const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const path = require('path');
require('dotenv').config(); // Carga las variables de .env

const app = express();
const PORT = 3000;

// Configuración de conexión a SQL Server (usa variables del .env)
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT),
    options: {
        trustServerCertificate: true // Necesario para SQL Server Express
    }
};

// Middlewares
app.use(bodyParser.urlencoded({ extended: true }));
// Servir archivos estáticos (CSS, JS, imágenes) desde la carpeta 'public'
app.use(express.static(path.join(__dirname, 'public'))); 

// ------------------------------------------
// Rutas de Vistas
// ------------------------------------------

// Ruta Principal: Sirve la página de Login
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

// Ruta del Dashboard: Sirve el Diseño de la UI (No funcional aún)
app.get('/dashboard', (req, res) => {
    // El diseño completo de la UI del proyecto (No debe ser funcional) [cite: 62]
    res.sendFile(path.join(__dirname, 'views', 'dashboard.html'));
});

// ------------------------------------------
// Lógica de Autenticación (Login Resuelto) [cite: 61]
// ------------------------------------------

app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    // 1. Encriptación (Base64) para machear con la BD [cite: 36, 37]
    const passwordHash = Buffer.from(password).toString('base64');

    try {
        await sql.connect(dbConfig);
        const request = new sql.Request();
        
        // El sistema deberá consultar a una tabla de usuarios de la BD y machear las credenciales [cite: 34]
        request.input('user', sql.VarChar, username);
        request.input('hash', sql.VarChar, passwordHash);

        const result = await request.query(
            `SELECT nombre_usuario, rol 
             FROM Usuarios 
             WHERE nombre_usuario = @user AND password_hash = @hash`
        );

        if (result.recordset.length === 1) {
            // Después de una autenticación exitosa, el usuario debe ser redirigido automáticamente [cite: 38]
            return res.redirect('/dashboard');
        } else {
            // Credenciales incorrectas
            return res.status(401).send('Usuario o contraseña incorrectos. <a href="/">Intentar de nuevo</a>');
        }

    } catch (err) {
        console.error('Error en la conexión o consulta a la BD:', err);
        res.status(500).send('Error interno del servidor. Verifique la conexión a SQL Server.');
    } finally {
        sql.close();
    }
});

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor Essenza corriendo en http://localhost:${PORT}`);
    console.log(`Usuario de prueba: admin / 123456`);
});