CREATE TABLE Cities(
    CityId SERIAL PRIMARY KEY,
    Name varchar(20) NOT NULL
);

ALTER TABLE Cities
    ALTER COLUMN Name TYPE VARCHAR(50);

ALTER TABLE Cities
    ADD COLUMN GeoLocation POINT;

CREATE TABLE Restaurants(
    RestaurantId SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    CityId INT REFERENCES Cities(CityId),
    Capacity INT NOT NULL,
    Offers_Delivery BOOLEAN NOT NULL,
    Working_Hours VARCHAR(50) NOT NULL
);

ALTER TABLE Restaurants
    ALTER COLUMN Name TYPE VARCHAR(50);

CREATE TABLE Dish_Category(
    CategoryId SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL
);

CREATE TABLE Dishes(
    DishId SERIAL PRIMARY KEY,
    Name VARCHAR(30) NOT NULL,
    CategoryId INT REFERENCES Dish_Category(CategoryId),
    Price DECIMAL(10,2) NOT NULL,
    Calories INT NOT NULL
);

ALTER TABLE Dishes
    ALTER COLUMN Name TYPE VARCHAR(50);

CREATE TABLE Menu(
    RestaurantId INT REFERENCES Restaurants(RestaurantId),
    DishId INT REFERENCES Dishes(DishId),
    Available BOOLEAN NOT NULL,
    PRIMARY KEY(RestaurantId, DishId)
);

CREATE TABLE Users(
    UserId SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL
);

ALTER TABLE Users
    ADD COLUMN Surname VARCHAR(50) NOT NULL;

ALTER TABLE Users
    ADD COLUMN Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Male', 'Female'));

CREATE TABLE Loyalty_Card(
    UserId INT PRIMARY KEY REFERENCES Users(UserId),
    Issue_date DATE NOT NULL    
);

CREATE TABLE Orders(
    OrderId SERIAL PRIMARY KEY,
    UserId INT REFERENCES Users(UserId),
    Total_Amount DECIMAL(10,2) NOT NULL,
    Delivery_type VARCHAR(20) CHECK(Delivery_type IN('delivery','restaurant')),
    Order_Date TIMESTAMP NOT NULL    
);

CREATE TABLE Order_Meals(
    OrderId INT REFERENCES Orders(OrderId),
    DishId INT REFERENCES Dishes(DishId),
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(OrderId,DishId)
);

ALTER TABLE Order_Meals
DROP CONSTRAINT IF EXISTS order_meals_dishid_fkey;

ALTER TABLE Order_Meals
ADD CONSTRAINT order_meals_dishid_fkey
FOREIGN KEY (DishId) REFERENCES Dishes(DishId) ON DELETE CASCADE;

CREATE TABLE Staff_Roles(
    RoleId SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL
);

CREATE TABLE Staff(
    StaffId SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Email VARCHAR(30) UNIQUE NOT NULL,
    Has_Drivers_License BOOLEAN DEFAULT FALSE,
    BirthDate DATE NOT NULL,
    RoleId INT REFERENCES Staff_Roles(RoleId),
    RestaurantId INT REFERENCES Restaurants(RestaurantId)
);

ALTER TABLE Staff
	ALTER COLUMN Name TYPE VARCHAR(50);
	
ALTER TABLE Staff
	ALTER COLUMN Email TYPE VARCHAR(100);
	
ALTER TABLE Staff
    ADD COLUMN Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Male', 'Female'));

ALTER TABLE Staff
    ADD COLUMN Surname VARCHAR(50) NOT NULL;

ALTER TABLE Staff
    ADD CONSTRAINT chk_chef_age
    CHECK (
        RoleId != 1 OR (AGE(BirthDate) >= INTERVAL '18 years')
    );

ALTER TABLE Staff
    ADD CONSTRAINT chk_driver_license
    CHECK (
        RoleId != 2 OR Has_Drivers_License = TRUE
    );

CREATE TABLE Deliveries(
    DeliveryId SERIAL PRIMARY KEY,
    OrderId INT REFERENCES Orders(OrderId),
    StaffId INT REFERENCES Staff(StaffId),
    Delivery_Time TIMESTAMP NOT NULL,
    Note TEXT
);

CREATE TABLE Reviews(
    ReviewId SERIAL PRIMARY KEY,
    DeliveryId INT NULL REFERENCES Deliveries(DeliveryId),
    OrderId INT NULL REFERENCES Orders(OrderId),
    Rating INT CHECK(Rating BETWEEN 1 and 5),
    Comment TEXT    
);
