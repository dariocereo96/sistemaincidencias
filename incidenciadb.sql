-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-08-2024 a las 18:31:39
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `incidenciadb`
--
CREATE DATABASE IF NOT EXISTS `incidenciadb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `incidenciadb`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE `empresas` (
  `id` int(11) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `ruc` varchar(13) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empresas`
--

INSERT INTO `empresas` (`id`, `razon_social`, `direccion`, `telefono`, `correo`, `ruc`, `usuario_id`) VALUES
(24, 'AGRICOLA S.A', 'PUEBLOVIEJO', '0989991105', 'agricolasa@gmail.com', '1204030403111', 69),
(25, 'COMERCIAL VILLACRES', 'QUITO, AV 10', '0948438434', 'comercialvillacres@gmail.com', '2204304343443', 73);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`) VALUES
(3, 'administrador'),
(5, 'digitador'),
(4, 'superadministrador'),
(2, 'tecnico'),
(1, 'usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subtipoticket`
--

CREATE TABLE `subtipoticket` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `tipo_id` int(11) DEFAULT NULL,
  `prioridad` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subtipoticket`
--

INSERT INTO `subtipoticket` (`id`, `nombre`, `tipo_id`, `prioridad`) VALUES
(1, 'Fallo de disco duro', 1, 'critica'),
(2, 'Problema con la RAM', 1, 'alta'),
(3, 'Fallo en la fuente de poder', 1, 'alta'),
(4, 'Overheating', 1, 'critica'),
(5, 'Fallo de ventilador', 1, 'media'),
(6, 'Problema con la placa base', 1, 'critica'),
(7, 'Problema de conectores', 1, 'media'),
(8, 'Problema de tarjeta gráfica', 1, 'alta'),
(9, 'Fallo de periférico', 1, 'baja'),
(10, 'Mantenimiento preventivo', 1, 'baja'),
(11, 'Error de instalación', 2, 'media'),
(12, 'Bug en el software', 2, 'alta'),
(13, 'Actualización fallida', 2, 'alta'),
(14, 'Compatibilidad de software', 2, 'media'),
(15, 'Problema de licencia', 2, 'baja'),
(16, 'Crash de aplicación', 2, 'critica'),
(17, 'Problema de rendimiento', 2, 'alta'),
(18, 'Configuración incorrecta', 2, 'media'),
(19, 'Software malicioso', 2, 'critica'),
(20, 'Solicitud de nueva funcionalidad', 2, 'baja'),
(21, 'Problema de conexión', 3, 'alta'),
(22, 'Lentitud en la red', 3, 'media'),
(23, 'Pérdida de paquetes', 3, 'alta'),
(24, 'Configuración de router', 3, 'media'),
(25, 'Problema de firewall', 3, 'alta'),
(26, 'Problema de DNS', 3, 'alta'),
(27, 'Problema de DHCP', 3, 'media'),
(28, 'Caída de la red', 3, 'critica'),
(29, 'Problema de VPN', 3, 'alta'),
(30, 'Interferencia de señal', 3, 'media'),
(31, 'Problema de inicio de sesión', 4, 'media'),
(32, 'Restablecimiento de contraseña', 4, 'baja'),
(33, 'Consulta de uso de software', 4, 'baja'),
(34, 'Capacitación de usuario', 4, 'baja'),
(35, 'Configuración de cuenta', 4, 'media'),
(36, 'Permisos de acceso', 4, 'alta'),
(37, 'Solicitud de acceso a recursos', 4, 'media'),
(38, 'Problema de correo electrónico', 4, 'alta'),
(39, 'Problema con dispositivos móviles', 4, 'media'),
(40, 'Asistencia técnica general', 4, 'baja'),
(41, 'Problema general', 5, 'media'),
(42, 'Consulta administrativa', 5, 'baja'),
(43, 'Solicitud de soporte técnico', 5, 'media'),
(44, 'Reclamo o queja', 5, 'alta'),
(45, 'Problema de seguridad', 5, 'critica'),
(46, 'Consulta sobre políticas', 5, 'baja'),
(47, 'Problema con equipos nuevos', 5, 'media'),
(48, 'Mantenimiento de instalaciones', 5, 'baja'),
(49, 'Solicitud de recursos', 5, 'media'),
(50, 'Otro tipo de problema', 5, 'baja'),
(51, 'Otro tipo de problema', 1, 'baja'),
(52, 'Otro tipo de problema', 2, 'baja'),
(53, 'Otro tipo de problema', 3, 'baja'),
(54, 'Otro tipo de problema', 4, 'baja');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tecnicos`
--

CREATE TABLE `tecnicos` (
  `id` int(11) NOT NULL,
  `cedula` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tecnicos`
--

INSERT INTO `tecnicos` (`id`, `cedula`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `usuario_id`) VALUES
(16, '1205487955', 'PABLO', 'GUALANCAAY', 'pablodariocerezo@gmail.com', 'Vinces', '0989991105', 70),
(17, '1202591122', 'JUAN', 'GUAMAN', 'juan@gmail.com', 'QUITO, AV CALDERON', '0989995110', 71);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_id` int(11) DEFAULT NULL,
  `prioridad` varchar(20) DEFAULT NULL,
  `estado` varchar(10) DEFAULT 'abierto',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_resolucion` datetime DEFAULT NULL,
  `asignado_a` int(11) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `lugar` varchar(100) DEFAULT NULL,
  `encargado` varchar(100) DEFAULT NULL,
  `subtipo_id` int(11) DEFAULT NULL,
  `comentario` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tickets`
--

INSERT INTO `tickets` (`id`, `titulo`, `descripcion`, `tipo_id`, `prioridad`, `estado`, `fecha_creacion`, `fecha_resolucion`, `asignado_a`, `usuario_id`, `lugar`, `encargado`, `subtipo_id`, `comentario`) VALUES
(76, 'no se puede conectar al internet', 'sdsdsdsdsdsd', 3, 'alta', 'cerrado', '2024-08-13 23:59:14', '2024-08-14 10:01:52', 71, 69, 'area de ventas', 'Ing Marlos Suarez - Tecnologo', 22, 'se reviso la red y se verifico que hay un problema en un router y se lo cambio'),
(77, 'falla en windows', 'no inicia el windows se queda congelado', 2, 'critica', 'cerrado', '2024-08-14 10:05:12', '2024-08-14 10:07:45', 71, 73, 'area de ventas', 'ing carlos - vendedor', 12, 'se reviso el equipo y se comenzo a reinstalar el wiwdosw'),
(78, 'formateo de computador', 'necesito que se formatee un equipo por que esta muy lento', 4, 'media', 'cerrado', '2024-08-14 10:10:05', '2024-08-14 10:11:38', 70, 73, 'sin expecificar', 'Ing Marlos Suarez - Tecnologo', 40, 'se efectuo el formateo del equipo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoticket`
--

CREATE TABLE `tipoticket` (
  `id` int(11) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipoticket`
--

INSERT INTO `tipoticket` (`id`, `tipo`) VALUES
(1, 'Hardware'),
(5, 'Otro'),
(3, 'Red'),
(2, 'Software'),
(4, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `salt` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `correo_electronico`, `contrasena`, `rol_id`, `salt`) VALUES
(53, 'superadministrador', 'superadministrador@softcorp.com', '21BDg7Cvyh3WDQgxoolzZA==', 4, 'aRNqLKt0jnFRiYLVdH8y+g=='),
(55, 'digitador', 'digitador@softcorp.com', 'amTq16nlX9FsTK+VsdT6xw==', 5, 'jmVORxiWZPloI+LPxNrpkA=='),
(65, 'administrador', 'admininstrador@softcorp.com', 'ENg5LMT7pczQI8ipoAgBjQ==', 3, '28NFcFAZ5nYBlL+DMWDNdQ=='),
(69, 'agricola_sa', 'agricolasa@gmail.com', 'd5rLzKCp3XH/JZFy8BL1MQ==', 1, 'fCfcFNq+S146/05iQMhA/w=='),
(70, 'pablocerezotecnico1', 'pablocerezo@softcorp.com', 'Ius/LXqboYqClJARONQMfw==', 2, 'w/Ijwv+goSzx2Hs2yRCzng=='),
(71, 'juanguamantecnico2', 'juanguaman@softcorp.com', 'JTPCXpMgJarOhFKyBE7HEw==', 2, 'rGe5ZVaX6xfV6txwi9gv/g=='),
(72, 'digitador2', 'digitador2@softcorp.com', 'xXHOEasjYmUUO7opjSfwFA==', 5, '6wljYNZzS30fxVy3gQMRPA=='),
(73, 'comercialvillacres', 'comercialvillacres@gmail.com', '5kWIMAqb8+E6Qq3ycvx5ww==', 1, 'SMotcWsxn8sB0t7K5a2j0w==');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresas_FK` (`usuario_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `subtipoticket`
--
ALTER TABLE `subtipoticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subtipoticket_ibfk_1` (`tipo_id`);

--
-- Indices de la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tecnicos_ibfk_1` (`usuario_id`);

--
-- Indices de la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tipo_id` (`tipo_id`),
  ADD KEY `asignado_a` (`asignado_a`),
  ADD KEY `tickets_FK` (`subtipo_id`),
  ADD KEY `tickets_FK_1` (`usuario_id`);

--
-- Indices de la tabla `tipoticket`
--
ALTER TABLE `tipoticket`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tipo` (`tipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo_electronico` (`correo_electronico`),
  ADD KEY `rol_id` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `subtipoticket`
--
ALTER TABLE `subtipoticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT de la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `tipoticket`
--
ALTER TABLE `tipoticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD CONSTRAINT `empresas_FK` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Filtros para la tabla `subtipoticket`
--
ALTER TABLE `subtipoticket`
  ADD CONSTRAINT `subtipoticket_ibfk_1` FOREIGN KEY (`tipo_id`) REFERENCES `tipoticket` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  ADD CONSTRAINT `tecnicos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Filtros para la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_FK` FOREIGN KEY (`subtipo_id`) REFERENCES `subtipoticket` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tickets_FK_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`tipo_id`) REFERENCES `tipoticket` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`asignado_a`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
