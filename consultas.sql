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