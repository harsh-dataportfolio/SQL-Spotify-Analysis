SELECT *
FROM Spotify_dataset;

SELECT COUNT(*)
FROM Spotify_dataset;

SELECT 
COUNT(DISTINCT Artist)
FROM Spotify_dataset;

SELECT 
COUNT(DISTINCT Album)
FROM Spotify_dataset;

SELECT
DISTINCT Album,
Danceability,
Energy,
Acousticness,
Instrumentalness
FROM Spotify_dataset;

SELECT 
DISTINCT Album_type
FROM Spotify_dataset;

SELECT 
MAX(duration_min) AS MaxDuration,
MIN(duration_min) AS MinDuration
FROM Spotify_dataset;

SELECT *
FROM Spotify_dataset
WHERE Duration_min = 0;

SELECT 
AVG(DUration_min) AS AvgDurationMinutes
FROM Spotify_dataset;

-- Deleting columns where min duration is 0

DELETE FROM Spotify_dataset
WHERE Duration_min = 0;

SELECT
COUNT(DISTINCT Channel) AS DistinctChannels
FROM Spotify_dataset;

-- Name of albums along with their artists.
SELECT 
Artist,
Track
FROM Spotify_dataset;

-- Top 10 most energetic songs

SELECT
TOP 10
Artist,
Track,
Energy
FROM Spotify_dataset
ORDER BY Energy DESC;

--Which artist has the highest average danceability

SELECT 
TOP 1
Artist,
AvgDanceability
FROM(
	SELECT
	Artist,
	AVG(Danceability) AS AvgDanceability
	FROM Spotify_dataset
	GROUP BY Artist
	) AS Subquery1
ORDER BY AvgDanceability DESC;

		
-- Songs where the no. of streams is more then 1 billion
SELECT
*
FROM Spotify_dataset
WHERE Stream>1000000000;

-- Total no. of tracks belonging to single album type

SELECT 
Track,
Album_type
FROM Spotify_dataset
WHERE Album_type= 'Single';

-- Top 10 most Viewed songs on youtube

SELECT
TOP 10
Track,
Artist,
Album,
Views
FROM Spotify_dataset
WHERE most_playedon = 'Youtube'
ORDER BY Views DESC;

-- Find the top 5 tracks with the highest energy value.

SELECT 
TOP 5
Track,
MAX(Energy) AS MaxEnergyValue
FROM Spotify_dataset
GROUP BY Track
ORDER BY MAX(Energy) DESC;

-- Which tracks are the most acoustic or instrumental?

SELECT
Track,
MAX(Acousticness) AS MaxAcoustic,
MAX(Instrumentalness) AS MaxInstrumental
FROM Spotify_dataset
GROUP BY Track
ORDER BY MaxAcoustic DESC,
		MaxInstrumental DESC;

-- Which artist has the most total likes on youtube?

SELECT
TOP 1
Artist,
SUM(Likes) AS TotalLikes
FROM Spotify_dataset
WHERE most_playedon = 'youtube'
GROUP BY Artist
ORDER BY TotalLikes DESC;

-- List of all the tracks with their views and likes where official_video= TRUE/1,

SELECT 
TOP 100
Track,
SUM(Views)AS TotalViews,
SUM(likes) AS TotalLikes
FROM Spotify_dataset
WHERE official_video =1
GROUP BY Track
ORDER BY SUM(Views) DESC;

-- For each album calculate total views of all associated tracks 

SELECT 
Album,
Track,
SUM(Views) AS TotalViews 
FROM Spotify_dataset
GROUP BY Album,
		Track
ORDER BY SUM(Views) DESC;

--Find top 5 Albums By Total Streams

SELECT
TOP 5
Album,
SUM(Stream) TotalStreams
FROM Spotify_dataset
GROUP BY Album
ORDER BY TotalStreams DESC;

--Which Top 10 artist have the most impactful tracks across both youtube and spotify?

SELECT 
TOP 10
Artist,
SUM(Views + Stream) AS TotalImpact
FROM Spotify_dataset
WHERE Views IS NOT NULL AND
		Stream IS NOT NULL
GROUP BY Artist
ORDER BY TotalImpact DESC;

--Retrieve track names that have been streamed on spotify more than youtube.

  SELECT 
	 Artist
	 Track,
	 Title,
	 Stream AS SpotifyStreams,
	 Views AS Youtubeviews
 FROM Spotify_dataset
 WHERE Stream > Views
	 ORDER BY (Stream - Views) DESC;

-- Find top 3 most viewed tracks for each artist.

SELECT 
*
FROM
( SELECT
		Artist,
		Track,
		SUM(Views) AS TotalViews,
		DENSE_RANK() OVER(PARTITION BY Artist ORDER BY SUM(Views) DESC) AS TrackRankedOnViews
	FROM Spotify_dataset
	GROUP BY Artist,
	Track
) AS RankedTracks
WHERE TrackRankedOnViews <=3
ORDER BY Artist, TrackRankedOnViews;

-- Identfy the top 5 tracks on the basis of popularity(Likes, Views AND Streams).
SELECT
TOP 5
	Track,
	SUM(Likes) AS TotalLikes,
	SUM(Views) AS TotalViews,
	SUM(Stream) AS TotalStreams,

	ROUND(SUM(Likes * 0.4+ Views *0.3+ Stream *0.3), 2) AS PopularityScore
FROM Spotify_dataset
GROUP BY Track
ORDER BY PopularityScore DESC;


--Which albums perform the best overall- Considering total streams, likes and user engagement(comments)?

SELECT
	TOP 100
	Album,
	SUM(Stream) AS TotalStreams,
	SUM(Likes) AS TotalLikes,
	SUM(Comments) AS TotalComments,
	ROUND(SUM(Stream* 0.4 + Likes* 0.35 + Comments* 0.25 ), 2) AS NormalizedOverallPerfomance
FROM Spotify_dataset
GROUP BY Album
ORDER BY NormalizedOverallPerfomance DESC;