--Database Schema
--Artist(artistID (PK), firstName, lastName, city, state)
--Materials(materialsID (PK), category, medium)
--Gallery(gallery (PK), building)
--TicketPrice(year (PK), ticketPrice)
--Artwork(year (PK)(FK), artworkID (PK), artistID (FK), title, materialsID(FK), 
-- price, chosen, purchased, purchaseDate, gallery(FK))


-- Display a list of artists from MA & CT
--Sort first by state
--Then by city
--Then by last name
--Display as
--ArtistName            Location    
--FirstName LastName    City, ST  

select city || ', ' || state AS location, firstName || ' ' || lastName AS ArtistName
from Artist
where state = 'MA' OR state='CT'
ORDER BY state, city, lastName; 

-- increase ticket prices by $10 for years between 2013 and 2021 (inclusive)
update TicketPrice 
set ticketPrice = ticketPrice + 10
where 2013 <= year AND year <= 2021;
select * from TicketPrice;

-- display a list of artworks including the building and gallery they are in, the title, and the price
-- select artworks purchased or displayed in the sculpture garden
-- Display purchased date in format SEP 9, 2022 w heading PurchasedDate
-- sort by building, then gallery, then by title
select building, gallery, title, price, to_char(purchaseDate, 'Mon dd, yyyy') AS PurchaseDate
from Artwork NATURAL JOIN Gallery
where gallery = 'Sculpture Garden'
ORDER BY building, gallery, title;

-- Display artworks including first name, last name, the title, the medium used, 
-- 2*price as pandemicPrice, gallery
-- only display artworks originally priced between 100 and 200 (inclusive), are in the
-- oil category, and are in gund OR walker gallery
-- sort by last name, first name, and then title
select firstName, lastName, title, category, 2*price AS pandemicPrice, gallery
from Artwork
join Artist ON Artist.artistID = Artwork.artistID
join Materials ON Artwork.materialsID = Materials.materialsID
where (100<=price AND price<=200) AND (category = 'Oil') AND (gallery='Gund' OR gallery='Walker')
ORDER BY lastName, firstName, title;

-- display the gallery and then category (no copies of same category in one gallery)
-- sort by gallery and then category
select distinct Artwork.gallery, category
from Artwork
join Materials ON Materials.materialsID = Artwork.materialsID
join Gallery ON Gallery.gallery = Artwork.gallery
where building='Stein Conservatory'
ORDER BY gallery, category;