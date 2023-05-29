CREATE DATABASE "desafio3-Juan-Aros-666";

\c "desafio3-Juan-Aros-666"

CREATE TABLE usuarios (
    id SERIAL,
    email VARCHAR,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    rol VARCHAR(15)
);

CREATE TABLE posts (
    id SERIAL,
    titulo VARCHAR,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

CREATE TABLE comentarios (
    id SERIAL,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES
('juan@email.cl', 'Juan', 'Aros', 'administrador'),
('ww@email.cl', 'Walter', 'White', 'usuario'),
('jesse@email.cl', 'Jesse', 'Pinkman', 'usuario'),
('gus@email.cl', 'Gustavo', 'Fring', 'usuario'),
('saul@email.cl', 'Saul', 'Goodman', 'usuario');

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
('Titulo del post 1', 'Contenido del post 1', '2023-05-19 17:22:00', '2023-05-20 03:33:33', true, 1),
('Titulo del post 2', 'Contenido del post 2', '2023-05-17 01:13:00', '2023-05-19 06:30:00', false, 1),
('Titulo del post 3', 'Contenido del post 3', '2023-05-18 11:25:00', '2023-05-18 11:11:11', false, 2),
('Titulo del post 4', 'Contenido del post 4', '2023-05-20 22:38:00', '2023-05-21 17:00:00', true, 3),
('Titulo del post 5', 'Contenido del post 5', '2023-05-13 13:02:00', '2023-05-15 10:11:31', false, null);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES
('Contenido comentario 1', '2023-05-16 10:00:00', 1, 1),
('Contenido comentario 2', '2023-05-17 12:00:00', 2, 1),
('Contenido comentario 3', '2023-05-18 14:00:00', 3, 1),
('Contenido comentario 4', '2023-05-19 16:00:00', 1, 2),
('Contenido comentario 5', '2023-05-20 18:00:00', 2, 2);

    -- Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. 
    -- nombre e email del usuario junto al titulo y contenido del post
SELECT u.nombre, u.email, p.titulo, p.contenido 
FROM usuarios u
INNER JOIN posts p ON u.id = p.usuario_id;

    -- Muestra el id, titulo y contenido de los posts de los administradores.
    -- El administrador puede ser cualquier id y debe ser seleccionado dinamicamente.
SELECT u.id, p.titulo, p.contenido 
FROM posts p
INNER JOIN usuarios u ON u.id = p.usuario_id 
WHERE u.rol = 'administrador'
GROUP BY u.id, p.titulo, p.contenido;

    -- Cuenta la cantidad de posts de cada usuario.
    -- La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT u.id, u.email, COUNT(p.id) AS num_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY u.id;

    -- Muestra el email del usuario que ha creado mas posts.
    -- Aqui la tabla resultante tiene un unico registro y muestra solo el email
SELECT u.email 
FROM usuarios u
INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

    -- Muestra la fecha del ultimo post de cada usuario
SELECT u.nombre, u.apellido, MAX(fecha_creacion) AS ultimo_post 
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.nombre, u.apellido
ORDER BY ultimo_post;

    -- Muestra el titulo y el contenido del post (articulo) con mas comentarios
SELECT p.titulo, p.contenido, COUNT(c.post_id) AS num_comentarios
FROM posts p
INNER JOIN comentarios c ON c.post_id = p.id
GROUP BY p.titulo, p.contenido
ORDER BY num_comentarios DESC
LIMIT 1;

    -- Muestra en una tabla el titulo de cada post, el contenido de cada post,
    -- y el contenido de cada comentario asociado a los posts mostrados, 
    -- junto con el email del usuario que lo escribio
SELECT p.titulo, p.contenido AS contenido_post, c.contenido AS comentario_post, u.email
FROM posts p
INNER JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u ON u.id = c.usuario_id
ORDER BY p.titulo;

    -- Muestra el contenido del ultimo comentario de cada usuario
SELECT u.nombre, u.apellido, c.contenido
FROM usuarios u
INNER JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id)
ORDER BY c.contenido ASC;


    -- Muestra los emails de los usuarios que no han escrito ningun comentario
SELECT u.email, COUNT(c.usuario_id) AS num_comentarios
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.usuario_id) = 0;
