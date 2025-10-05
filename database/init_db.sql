-- 1. CREACI�N Y USO DE LA BASE DE DATOS
CREATE DATABASE EssenzaDB;
GO
USE EssenzaDB;
GO
-- 2. CREACI�N DE TABLAS (CAN�NICO DE LA BD)
-- Tabla de Usuarios (Requisito de Login)
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL, -- Contrase�a protegida mediante Base64 (MTIzNDU2 = 123456)
    rol VARCHAR(20) NOT NULL
);
-- Entidad 1: Marcas (Base para Drill-Down/Up Nivel 1)
CREATE TABLE Marcas (
    id_marca INT PRIMARY KEY IDENTITY(1,1),
    nombre_marca VARCHAR(100) NOT NULL UNIQUE,
    tipo VARCHAR(50) -- 'DISE�ADOR' o 'ARABES'
);
-- Entidad 2: Perfumes (Productos) (Base para Drill-Down/Up Nivel 2)
CREATE TABLE Perfumes (
    id_perfume INT PRIMARY KEY IDENTITY(1,1),
    id_marca INT FOREIGN KEY REFERENCES Marcas(id_marca),
    nombre_perfume VARCHAR(150) NOT NULL,
    nombre_completo VARCHAR(255) NOT NULL -- Nombre completo para mostrar en la web
);
-- Entidad para Nivel 3 de Drill-Down (Los formatos)
CREATE TABLE Formatos (
    id_formato INT PRIMARY KEY IDENTITY(1,1),
    ml INT NOT NULL UNIQUE
);
-- Tabla que relaciona Perfumes y Formatos con su precio final.
CREATE TABLE Perfume_Precio (
    id_perfume_precio INT PRIMARY KEY IDENTITY(1,1),
    id_perfume INT FOREIGN KEY REFERENCES Perfumes(id_perfume),
    id_formato INT FOREIGN KEY REFERENCES Formatos(id_formato),
    precio DECIMAL(10, 2) NOT NULL,
    CONSTRAINT UQ_Perfume_Formato UNIQUE (id_perfume, id_formato)
);
-- Entidad 3: Clientes (Para Indicador Visual - Semaforizaci�n)
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    estado VARCHAR(10) NOT NULL -- 'ACTIVO', 'INACTIVO' o 'PENDIENTE'
);
-- Entidad 4: Ventas (Transacciones)
CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    fecha_venta DATE NOT NULL,
    id_cliente INT FOREIGN KEY REFERENCES Clientes(id_cliente),
    total DECIMAL(10, 2) NOT NULL
);
-- Tabla de Detalle para las Ventas
CREATE TABLE DetalleVenta (
    id_detalle INT PRIMARY KEY IDENTITY(1,1),
    id_venta INT FOREIGN KEY REFERENCES Ventas(id_venta),
    id_perfume_precio INT FOREIGN KEY REFERENCES Perfume_Precio(id_perfume_precio), -- Apunta a la combinaci�n Perfume+Formato
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL
);
-- 3. INSERTS DE DATOS INICIALES Y CAT�LOGO
-- USUARIO DE PRUEBA (LOGIN)
INSERT INTO Usuarios (nombre_usuario, password_hash, rol) VALUES
('admin', 'MTIzNDU2', 'Administrador');
-- CLIENTES DE PRUEBA (SEMAFORIZACI�N)
INSERT INTO Clientes (nombre, apellido, email, estado) VALUES
('Mauricio', 'Garcia', 'm.garcia@test.com', 'ACTIVO'),
('Cristian', 'Medin', 'c.medin@test.com', 'INACTIVO'),
('Alejo', 'Nardon', 'a.nardon@test.com', 'PENDIENTE');
-- FORMATOS DISPONIBLES
INSERT INTO Formatos (ml) VALUES
(39), (50), (60), (75), (90), (100), (105), (120), (200);
-- MARCAS (DISE�ADOR Y ARABES)
INSERT INTO Marcas (nombre_marca, tipo) VALUES
('DIOR', 'DISE�ADOR'),
('CAROLINA HERRERA', 'DISE�ADOR'),
('YVES SAINT LAURENT', 'DISE�ADOR'),
('FRENCH', 'ARABES'),
('BHARARA', 'ARABES'),
('ARMAF', 'ARABES'),
('ODISSEY', 'ARABES'),
('AL HARAMAIN', 'ARABES'),
('AFNAN', 'ARABES'),
('LATTAFA', 'ARABES');
-- PERFUMES
INSERT INTO Perfumes (id_marca, nombre_perfume, nombre_completo) VALUES
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'DIOR'), 'SAUVAGE', 'DIOR SAUVAGE EDT'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'DIOR'), 'MISS DIOR', 'MISS DIOR EDP'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'FRENCH'), 'LIQUID BRUN', 'FRENCH LIQUID BRUN'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'CAROLINA HERRERA'), 'BAD BOY ELIXIR', 'CAROLINA HERRERA BAD BOY ELIXIR EDP'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'CAROLINA HERRERA'), 'PASION MAN', 'CAROLINA HERRERA PASION MAN EDP'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'CAROLINA HERRERA'), '212 VIP BLACK', 'CAROLINA HERRERA 212 VIP BLACK EDP'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'CAROLINA HERRERA'), '212 HEROES', 'CAROLINA HERRERA 212 HEROES EDT'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'BHARARA'), 'KING', 'BHARARA KING'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'ARMAF'), 'CLUB DE NUIR INTENSE', 'ARMAF CLUB DE NUIR INTENSE MAN'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'ODISSEY'), 'MANDARIN SKY', 'ODISSEY MANDARIN SKY'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'AL HARAMAIN'), 'AMBER OUD GOLD', 'AL HARAMAIN AMBER OUD GOLD EDITION'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'AFNAN'), '9PM', 'AFNAN 9PM'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'HONOR & GLORY', 'LATTAFA HONOR & GLORY'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'OUD FOR GLORY', 'LATTAFA OUD FOR GLORY'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'AMETHYST', 'LATTAFA AMETHYST'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'KHAMRAH', 'LATTAFA KHAMRAH'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'KHAMRAH QAHWA', 'LATTAFA KHAMRAH QAHWA'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'KHAMRAH DUKHAN', 'LATTAFA KHAMRAH DUKHAN'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'ASAD', 'LATTAFA ASAD'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'ASAD BOURBON', 'LATTAFA ASAD BOURBON'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'LATTAFA'), 'ASAD ZANZIBAR', 'LATTAFA ASAD ZANZIBAR'),
-- Perfume con comilla simple (escapada con doble comilla '')
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'YVES SAINT LAURENT'), 'Y L'' ELIXIR', 'YVES SAINT LAURENT Y L'' ELIXIR'),
((SELECT id_marca FROM Marcas WHERE nombre_marca = 'YVES SAINT LAURENT'), 'MYSLF LE PARFUM', 'YVES SAINT LAURENT MYSLF LE PARFUM');
-- PRECIOS POR PERFUME Y FORMATO (Relaci�n de Nivel 3)
INSERT INTO Perfume_Precio (id_perfume, id_formato, precio)
VALUES
-- DIOR SAUVAGE EDT
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'SAUVAGE'), (SELECT id_formato FROM Formatos WHERE ml = 100), 150000.00),
-- MISS DIOR EDP
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'MISS DIOR'), (SELECT id_formato FROM Formatos WHERE ml = 50), 160000.00),
-- FRENCH LIQUID BRUN
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'LIQUID BRUN'), (SELECT id_formato FROM Formatos WHERE ml = 100), 83000.00),
-- CAROLINA HERRERA BAD BOY ELIXIR EDP
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'BAD BOY ELIXIR'), (SELECT id_formato FROM Formatos WHERE ml = 100), 160000.00),
-- CAROLINA HERRERA PASION MAN EDP
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'PASION MAN'), (SELECT id_formato FROM Formatos WHERE ml = 100), 130000.00),
-- CAROLINA HERRERA 212 VIP BLACK EDP
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = '212 VIP BLACK'), (SELECT id_formato FROM Formatos WHERE ml = 50), 100000.00),
-- CAROLINA HERRERA 212 HEROES EDT
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = '212 HEROES'), (SELECT id_formato FROM Formatos WHERE ml = 90), 120000.00),
-- BHARARA KING
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'KING'), (SELECT id_formato FROM Formatos WHERE ml = 100), 86000.00),
-- ARMAF CLUB DE NUIR INTENSE MAN
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'CLUB DE NUIR INTENSE'), (SELECT id_formato FROM Formatos WHERE ml = 105), 58000.00),
-- ODISSEY MANDARIN SKY
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'MANDARIN SKY'), (SELECT id_formato FROM Formatos WHERE ml = 100), 64000.00),
-- AL HARAMAIN AMBER OUD GOLD EDITION 120ml
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'AMBER OUD GOLD'), (SELECT id_formato FROM Formatos WHERE ml = 120), 88000.00),
-- AL HARAMAIN AMBER OUD GOLD EDITION 75ml
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'AMBER OUD GOLD'), (SELECT id_formato FROM Formatos WHERE ml = 75), 90000.00),
-- AFNAN 9PM
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = '9PM'), (SELECT id_formato FROM Formatos WHERE ml = 100), 54000.00),
-- LATTAFA HONOR & GLORY
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'HONOR & GLORY'), (SELECT id_formato FROM Formatos WHERE ml = 100), 46000.00),
-- LATTAFA OUD FOR GLORY
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'OUD FOR GLORY'), (SELECT id_formato FROM Formatos WHERE ml = 100), 48000.00),
-- LATTAFA AMETHYST
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'AMETHYST'), (SELECT id_formato FROM Formatos WHERE ml = 100), 48000.00),
-- LATTAFA KHAMRAH
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'KHAMRAH'), (SELECT id_formato FROM Formatos WHERE ml = 100), 62000.00),
-- LATTAFA KHAMRAH QAHWA
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'KHAMRAH QAHWA'), (SELECT id_formato FROM Formatos WHERE ml = 100), 62000.00),
-- LATTAFA KHAMRAH DUKHAN
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'KHAMRAH DUKHAN'), (SELECT id_formato FROM Formatos WHERE ml = 100), 62000.00),
-- LATTAFA ASAD
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'ASAD'), (SELECT id_formato FROM Formatos WHERE ml = 100), 45000.00),
-- LATTAFA ASAD BOURBON
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'ASAD BOURBON'), (SELECT id_formato FROM Formatos WHERE ml = 100), 55000.00),
-- LATTAFA ASAD ZANZIBAR
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'ASAD ZANZIBAR'), (SELECT id_formato FROM Formatos WHERE ml = 39), 39000.00),
-- YVES SAINT LAURENT Y L' ELIXIR (CORREGIDO)
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'Y L'' ELIXIR'), (SELECT id_formato FROM Formatos WHERE ml = 60), 193000.00),
-- YVES SAINT LAURENT MYSLF LE PARFUM
((SELECT id_perfume FROM Perfumes WHERE nombre_perfume = 'MYSLF LE PARFUM'), (SELECT id_formato FROM Formatos WHERE ml = 200), 216000.00);