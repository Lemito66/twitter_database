-- Top 3 Usuarios de seguidores
select following_id, COUNT(follower_id) 'Seguidores Mayor Ranking'
from followers
group by following_id
ORDER by followers DESC
limit 3

-- Top 3 Usuarios pero haciendo join con la tabla users

select users.user_id, users.handle, users.first_name, following_id,  COUNT(follower_id) 'Seguidores Mayor Ranking'
from followers
inner join users on users.user_id = followers.following_id
group by following_id
ORDER by 'Seguidores Mayor Ranking' DESC
limit 3


-- Crear Tabla Tweets
CREATE TABLE tweets (
    tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    num_likes INT  DEFAULT 0,
    num_retweets INT  DEFAULT 0,
    num_comments INT  DEFAULT 0,
    created_at TIMESTAMP not null default (NOW()),
    PRIMARY KEY (tweet_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

insert into tweets (user_id, tweet_text) values (1, 'Hola Mundo'), (2, 'Lemito el mejor'), (3, 'Saliendo'), (1, 'Estudiando'), (2, 'Aprendiendo'), (3, 'Dormir');

-- Cuantos twwets tiene cada usuario
select user_id, COUNT(tweet_id) 'Tweets'
from tweets
group by user_id
ORDER by 'Tweets' DESC

-- Ahora con un join para ver el nombre del usuario 
select  users.first_name 'Nombre Usuario', COUNT(tweet_id) 'Tweets'
from tweets
inner join users on users.user_id = tweets.user_id
group by users.user_id
ORDER by 'Tweets' DESC

-- Tabla Likes
CREATE TABLE likes (
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    PRIMARY KEY (user_id, tweet_id)
);

--Obtener el numero de likes por tweet	
select tweet_id, COUNT(user_id) 'Likes'
from likes
group by tweet_id
ORDER by 'Likes' DESC

-- Con join para ver el nombre del usuario
select tweets.tweet_id, users.first_name 'Nombre Usuario', COUNT(likes.user_id) 'Likes'
from likes
inner join tweets on tweets.tweet_id = likes.tweet_id
inner join users on users.user_id = tweets.user_id
group by tweets.tweet_id
ORDER by 'Likes' DESC


-- Añadir una columna a la tabla users
ALTER TABLE users ADD COLUMN follower_count INT not null DEFAULT 0;


-- Triggers 
-- Trigger para actualizar el follower_count de la tabla users
-- El Delimiter es para que no se ejecute el trigger hasta que no se termine de escribir
Delimiter $$ 
CREATE TRIGGER increase_follower_count
AFTER INSERT ON followers
FOR EACH ROW
Begin
    UPDATE users
    SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END $$
Delimiter ;

-- Para menorar el número de followers
DELIMITER $$
CREATE TRIGGER decrease_follower_count
AFTER DELETE ON followers
FOR EACH ROW
BEGIN
    UPDATE users
    SET follower_count = follower_count - 1
    WHERE user_id = OLD.following_id;
END $$
DELIMITER ;
