--Ispis svih jela koja imaju cijenu manju od 15 eura.
SELECT * FROM Dishes d
WHERE d.Price< 15;

--Ispis svih narudžbi iz 2023. godine koje imaju ukupnu vrijednost veću od 50 eura.
SELECT * FROM Orders o
WHERE Total_Amount > 50;

--Ispis svih dostavljača s više od 100 (10) uspješno izvršenih dostava do danas.
SELECT s.staffid,s.Name, s.Surname, COUNT(d.DeliveryId) AS TotalDeliveries
FROM Staff s
INNER JOIN Deliveries d
ON d.StaffId = s.StaffId
GROUP BY s.StaffId, s.Name, s.Surname
HAVING COUNT(d.DeliveryId) > 10;

--Ispis svih kuhara koji rade u restoranima u Zagrebu.
SELECT s.Name, s.Surname, s.BirthDate, r.Name as Restaurant, sr.Name as Role FROM Staff s
INNER JOIN Restaurants r
ON s.RestaurantId = r.RestaurantId
INNER JOIN Cities c
on c.CityId = r.CityId
INNER JOIN Staff_Roles sr
on s.RoleId = sr.RoleId
WHERE c.Name = 'Zagreb' AND sr.Name = 'Chef'; 

--Ispis broja narudžbi za svaki restoran u Splitu tijekom 2024. godine.
SELECT r.RestaurantId,r.Name, c.Name as City, COUNT(o.OrderId) as Number_of_orders
FROM Restaurants r
INNER JOIN Cities c
on c.CityId = r.CityId
INNER JOIN Menu m
on m.RestaurantId = r.RestaurantId
INNER JOIN Dishes d
on d.DishId = m.DishId
INNER JOIN Order_Meals om
on om.DishId = d.DishId
INNER JOIN Orders o
on o.OrderId = om.OrderId
WHERE c.Name = 'Split' AND EXTRACT(YEAR FROM o.Order_Date) = 2024
GROUP BY r.Name, c.Name, r.RestaurantId;

-- Ispis svih jela u kategoriji "Deserti" koja su naručena više od 10 (4) puta u prosincu 2023.
SELECT d.Name as Dish_name, dc.Name as Category, SUM(om.Quantity) as OrdersNum FROM Dishes d
INNER JOIN Dish_Category dc
on d.CategoryId = dc.CategoryId
INNER JOIN Order_Meals om
on om.DishId = d.DishId
INNER JOIN Orders o
on o.OrderId = om.OrderId
GROUP BY d.Name, dc.Name, o.Order_Date
HAVING dc.Name = 'Dessert'
AND SUM(om.Quantity) > 4 
AND EXTRACT(YEAR FROM o.Order_Date) = 2023
AND EXTRACT(MONTH FROM o.Order_Date) = 12;

--Ispis broja narudžbi korisnika s prezimenom koje počinje na "M".
SELECT u.Name, u.Surname as Name, COUNT(u.UserId)
FROM Users u
INNER JOIN Orders o
on o.UserId = u.UserId
WHERE u.Surname LIKE 'M%'
GROUP BY u.Name, u.Surname;

--Ispis prosječne ocjene za restorane u Rijeci.
SELECT r.Name, c.Name as City, ROUND(AVG(re.Rating),1) as Rating FROM Restaurants r
INNER JOIN Cities c
on c.CityId = r.CityId
INNER JOIN Menu m
on m.restaurantid =r.restaurantid
INNER JOIN Dishes d
on d.DishId = m.DishId
INNER JOIN Order_Meals om
on om.DishId = d.DishId
INNER JOIN Orders o
on o.OrderId = om.OrderId
INNER JOIN Reviews re
on re.OrderId = o.OrderId
WHERE c.Name = 'Rijeka'
GROUP BY r.Name, c.Name;

--Ispis svih restorana koji imaju kapacitet veći od 30 stolova i nude dostavu.
SELECT r.Name, c.Name as City, r.Offers_Delivery  FROM Restaurants r
INNER JOIN Cities c
on c.CityId = r.CityId
WHERE r.Capacity > 30 
AND Offers_Delivery = true;

--Uklonite iz jelovnika jela koja nisu naručena u posljednje 2 godine.
DELETE FROM Dishes
WHERE DishId IN (
    SELECT d.DishId
    FROM Dishes d
    INNER JOIN Order_Meals om 
	ON d.DishId = om.DishId
    INNER JOIN Orders o 
	ON o.OrderId = om.OrderId
    WHERE o.Order_Date < CURRENT_DATE - INTERVAL '2 years'
);

--Izbrišite loyalty kartice svih korisnika koji nisu naručili nijedno jelo u posljednjih godinu dana.
DELETE FROM Loyalty_Card
WHERE UserId IN(
	SELECT u.UserId FROM Users u
	INNER JOIN Orders o
	on o.UserId = u.UserId
	INNER JOIN Loyalty_Card lc
	on lc.UserId = u.UserId
	WHERE o.Order_Date < CURRENT_DATE - INTERVAL '1 years'
);

