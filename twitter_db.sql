-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-07-2023 a las 00:12:25
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `twitter_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `followers`
--

CREATE TABLE `followers` (
  `follower_id` int(11) NOT NULL,
  `following_id` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `followers`
--

INSERT INTO `followers` (`follower_id`, `following_id`) VALUES
(1, 2),
(2, 1),
(3, 1),
(3, 2);

--
-- Disparadores `followers`
--
DELIMITER $$
CREATE TRIGGER `decrease_follower_count` AFTER DELETE ON `followers` FOR EACH ROW BEGIN
    UPDATE users
    SET follower_count = follower_count - 1
    WHERE user_id = OLD.following_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_follower_count` AFTER INSERT ON `followers` FOR EACH ROW Begin
    UPDATE users
    SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes`
--

CREATE TABLE `likes` (
  `user_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `likes`
--

INSERT INTO `likes` (`user_id`, `tweet_id`) VALUES
(1, 1),
(1, 4),
(2, 6),
(3, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tweets`
--

CREATE TABLE `tweets` (
  `tweet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tweet_text` varchar(280) NOT NULL,
  `num_likes` int(11) DEFAULT 0,
  `num_retweets` int(11) DEFAULT 0,
  `num_comments` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tweets`
--

INSERT INTO `tweets` (`tweet_id`, `user_id`, `tweet_text`, `num_likes`, `num_retweets`, `num_comments`, `created_at`) VALUES
(1, 1, 'Hola Mundo', 0, 0, 0, '2023-07-10 21:03:23'),
(2, 2, 'Lemito el mejor', 0, 0, 0, '2023-07-10 21:03:23'),
(3, 3, 'Saliendo', 0, 0, 0, '2023-07-10 21:03:23'),
(4, 1, 'Estudiando', 0, 0, 0, '2023-07-10 21:03:23'),
(5, 2, 'Aprendiendo', 0, 0, 0, '2023-07-10 21:03:23'),
(6, 3, 'Dormir', 0, 0, 0, '2023-07-10 21:03:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `handle` varchar(50) NOT NULL,
  `email_address` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone_number` char(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `follower_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`user_id`, `handle`, `email_address`, `first_name`, `last_name`, `phone_number`, `created_at`, `follower_count`) VALUES
(1, 'lemito66', 'lemito66@gmail.com', 'Emill', 'Logroño', '0986598457', '2023-07-10 19:19:47', 0),
(2, 'lemito-66', 'lemito-6@hotmail.com', 'Juan', 'Perez', '0965896532', '2023-07-10 19:44:59', 0),
(3, 'lemon', 'lemon@gmail.com', 'Maria', 'Lopez', '0965986523', '2023-07-10 19:45:22', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`follower_id`,`following_id`),
  ADD KEY `following_id` (`following_id`);

--
-- Indices de la tabla `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`user_id`,`tweet_id`),
  ADD KEY `tweet_id` (`tweet_id`);

--
-- Indices de la tabla `tweets`
--
ALTER TABLE `tweets`
  ADD PRIMARY KEY (`tweet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `handle` (`handle`),
  ADD UNIQUE KEY `email_address` (`email_address`),
  ADD UNIQUE KEY `phone_number` (`phone_number`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tweets`
--
ALTER TABLE `tweets`
  MODIFY `tweet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `followers_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `followers_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`user_id`);

--
-- Filtros para la tabla `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`tweet_id`) REFERENCES `tweets` (`tweet_id`);

--
-- Filtros para la tabla `tweets`
--
ALTER TABLE `tweets`
  ADD CONSTRAINT `tweets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
