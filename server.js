// server.js

// 🔹 Importación de módulos
const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const path = require('path');
require('dotenv').config(); // Cargar .env

// 🔹 Configuración base
const app = express();
const PORT = 3000;

// 🔹 Config BD (usa variables .env)
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT),
    options: { trustServerCertificate: true } // Requerido SQL Express
};

// 🔹 Middlewares
app.use(bodyParser.urlencoded({ extended: true })); // Leer formularios
app.use(express.static(path.join(__dirname, 'public'))); // Archivos estáticos

// 🔹 Rutas de vistas
app.get('/', (req, res) => { // Página login
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

app.get('/dashboard', (req, res) => { // Página dashboard
    res.sendFile(path.join(__dirname, 'views', 'dashboard.html'));
});

// 🔹 Lógica de login
app.post('/login', async (req, res) => {
    const { username, password } = req.body; // Datos del form

    const passwordHash = Buffer.from(password).toString('base64'); // Encriptar Base64

    try {
        await sql.connect(dbConfig); // Conectar BD
        const request = new sql.Request();

        // Parametrizar consulta
        request.input('user', sql.VarChar, username);
        request.input('hash', sql.VarChar, passwordHash);

        // Buscar usuario
        const result = await request.query(`
            SELECT nombre_usuario, rol 
            FROM Usuarios 
            WHERE nombre_usuario = @user AND password_hash = @hash
        `);

        // Validar resultado
        if (result.recordset.length === 1) {
            return res.redirect('/dashboard'); // Éxito → dashboard
        } else {
            return res.status(401).send('Usuario o contraseña incorrectos. <a href="/">Intentar de nuevo</a>');
        }

    } catch (err) {
        console.error('Error BD:', err); // Log error
        res.status(500).send('Error interno del servidor.');
    } finally {
        sql.close(); // Cerrar conexión
    }
});

// 🔹 Iniciar servidor
app.listen(PORT, () => {
    console.log(`Servidor Essenza corriendo en http://localhost:${PORT}`);
    console.log(`Usuario de prueba: admin / 123456`);
});
