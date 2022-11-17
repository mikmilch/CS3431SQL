/*
Materials (materialsID PK, category, medium)
TicketPrice (year PK, ticketPrice)
Building (buildingName PK, street, city, state, zipcode)
Gallery(gallery PK, floor, building FK)
Membership(memberLevel PK, yearlyFee, discount)
Artist(artistID PK, firstName, lastName, city, state, memberLevel FK)
Artwork(year PK FK, artworkID PK, artistID FK, title, materialsID FK, price, chosen, 
    purchased, purchaseDate, gallery FK)
NewArt(year PK FK, artworkID PK, artistID FK, title, materialsID FK, price, chosen, 
    purchased, purchaseDate, gallery FK)
*/

/*
2a
Display for each city:
    - the number of artworks in each gallery in the city
    - subtotals for each city
    - the grand total of all artworks
    - only include artworks from the years 2009,2013, and 2019
    - sort by city then by gallery
*/
SELECT city, Gallery.gallery, count(artworkID) ArtworkID_Count
FROM Building
JOIN Gallery on Gallery.building = Building.buildingName
JOIN Artwork on Artwork.gallery = Gallery.gallery
WHERE year=2009 OR year=2013 OR year=2019
GROUP BY ROLLUP (city, Gallery.gallery)
order by city, gallery;


/*
2b
- Display artistID, first name, last name
- For artists who had works in 2012 but NOT 2020 (see NewArt table)
- Sort by first name, and then by last name
- Use set theory and then a nested query in the from clause
*/
select B.artistID, B.firstName, B.lastName
from
    ((select Artwork.artistID
    from Artwork
    where year = 2012)
    minus
    (select NewArt.artistID
    from NewArt
    where year = 2020))A,
    (select Artist.artistID, firstName, lastName
    from Artist)B
where A.artistID = B.artistID
order by firstName, lastName;



/*
2c 
- Display the title, gallery, year, and price of artwork
- Price must be over $75
- Medium must contain glass
- Use subquery in the WHERE for the Materials data
- sort by title
*/
select title, gallery, year, price
from Artwork
where materialsID IN (
    select materialsID
    from Materials
    where medium LIKE '%glass%'
    )
    AND
    (price > 75)
order by title;


/*
2d
- select chosen items
- determine for each year and its corresponding ticket price
1. the total price of those items - as TotalArtValue
2. The actual amount that the art association received from the ticket sales 
        - as TicketRevenue
3. the difference between the two amounts above - as CustomerSurplus
*/
select TicketPrice.year, TicketPrice.ticketPrice, 
to_char(sum(Artwork.Price), '$999,990.00') AS TotalArtValue, 
to_char((TicketPrice.ticketPrice * count(Artwork.ArtworkID)), '$999,990.00') AS TicketRevenue,
to_char((sum(Artwork.Price) - (TicketPrice.ticketPrice * count(Artwork.ArtworkID))), '$999,990.00') AS CustomerSurplus
FROM TicketPrice
JOIN Artwork on TicketPrice.year = Artwork.year
WHERE Artwork.chosen IS NOT NULL
GROUP BY TicketPrice.year, ticketPrice
order by year DESC;


/*
2e
- select artist who donated the greatest toal value of artworks
-display
    - first name, lastname, and total value of artwork donated as "MaxDonatedValue"
*/
select A.firstName, A.lastName, B.MaxDonatedValue
FROM (select firstName, lastName, artistID
        from Artist) A,
    (select max((sum(Artwork.price))) AS MaxDonatedValue
        from Artwork
        group by artistid) B,
    (select artistID, sum(Artwork.price) AS sumArtwork
        from Artwork
        group by artistID) C
WHERE (A.artistID = C.artistID) AND (B.MaxDonatedValue = C.sumArtwork);