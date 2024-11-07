-- CREATE THE TABLE.
CREATE TABLE Spotify (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(50),
    Danceability FLOAT,
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views FLOAT,
    Likes BIGINT,
    Comments BIGINT,
    Licensed BOOLEAN,
    Official_video BOOLEAN,
    Stream BIGINT,
    Energy_liveness FLOAT,
    Most_playedon VARCHAR(50))


-- TOTAL NUMBER OF SONGS
SELECT COUNT(*) FROM Spotify


-- COUNT OF ARTISTS.
SELECT COUNT(DISTINCT Artist) FROM Spotify


-- COUNT OF ALBUMS.
SELECT COUNT(DISTINCT Album) FROM Spotify


-- TYPES OF ALBUM.
SELECT DISTINCT Album_type FROM SPOTIFY


-- MINIMUM & MAXIMUM DURATION  FROM THE TABLE.
SELECT MIN(Duration_min) FROM Spotify
SELECT MAX(Duration_min) FROM Spotify


-- DELETE THE SONG WITH DURATION IS ZERO.
DELETE FROM Spotify WHERE Duration_min = 0


-- FIND THE TOTAL NUMBER OF TRACKS BY EACH ARTIST.
SELECT COUNT(Track) AS Total_no_counts, Artist FROM Spotify 
GROUP BY Artist 
ORDER BY Total_no_counts DESC


-- RETRIEVE THE TRACKS WITH MORE THAN ONE BILLION STREAMS.
SELECT Track FROM Spotify 
WHERE Stream > 1000000000


-- FIND THE COUNT OF 'SINGLE' ALBUM TYPE.
SELECT COUNT(DISTINCT Track) FROM Spotify 
WHERE Album_type = 'single'


-- FIND THE TRACKS WITH ABOVE AVERAGE LIVENESS SCORE.
SELECT Track FROM Spotify 
WHERE Liveness > (SELECT AVG(Liveness) FROM Spotify)


-- FIND THE TOP 5 TRACKS WITH THE HIGHEST ENERGY VALUES.
SELECT DISTINCT(Track), Energy FROM Spotify 
ORDER BY Energy DESC 
LIMIT 5


-- FIND THE AVERAGE DANCEABILITY OF TRACKS IN EACH ALBUM.
SELECT Album, AVG(Danceability) AS Avg_danceability FROM Spotify 
GROUP BY Album 
ORDER BY Avg_danceability DESC


-- RETRIEVE THE TOP LIKED & VIEWED 'ORIGINAL VIDEO' TRACK (ORIGINAL VIDEO = TRUE).
SELECT Track, SUM(Views) AS Total_views, SUM(Likes) AS Total_likes FROM Spotify 
WHERE Official_video = 'TRUE' 
GROUP BY Album, Track 
ORDER BY Total_views DESC


-- RETREIVE THE TRACKS THAT HAS BEEN STREAMED MORE ON SPOTIFY THAN ON YOUTUBE.
SELECT * FROM (SELECT Track, 
    COALESCE(SUM(CASE WHEN Most_playedon = 'Youtube' THEN STREAM END),0) AS Streamed_on_Youtube, 
    COALESCE(SUM(CASE WHEN Most_playedon = 'Spotify' THEN STREAM END),0) AS Streamed_on_Spotify 
    FROM Spotify 
    GROUP BY Track) AS t 
    WHERE Streamed_on_Spotify > Streamed_on_youtube 
    AND Streamed_on_Youtube <> 0

    
-- FIND THE SUM OF LIKES FOR TRACKS BASED ON NUMBER OF VIEWS.
SELECT Track, Views, Likes, 
SUM(Likes) OVER (ORDER BY Views DESC) AS 
Cumulative_sum FROM Spotify
