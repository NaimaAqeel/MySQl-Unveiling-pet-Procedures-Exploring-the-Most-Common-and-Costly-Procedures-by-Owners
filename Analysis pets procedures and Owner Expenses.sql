SELECT *
FROM petowners;
SELECT *
FROM pets;
SELECT *
FROM proceduresdetails;
SELECT *
FROM procedureshistory;

---- 1 List the names of all pet owners along with the names of their pets.  

SELECT petowners.`name` AS owner_name, pets.`name` AS pet_name
FROM petowners
JOIN pets ON petowners.OwnerID= pets. OwnerID;

 --- 2 List all pets and their owner names, including pets that dont have recorded  owners.
 
SELECT petowners.`name` AS owner_name, pets.`name` AS pet_name
FROM petowners
RIGHT JOIN pets ON petowners.OwnerID= pets. OwnerID;

--- 3 Combine the information of pets and their owners, including those pets  without owners and owners without pets.  

SELECT petowners.`name` as owner_name, pets.`name` as pet_name
FROM petowners
LEFT JOIN pets ON petowners.OwnerID= pets. OwnerID
UNION
SELECT petowners.`name` as owner_name, pets.`name`AS pet_name
FROM petowners
RIGHT JOIN pets ON petowners.OwnerID= pets. OwnerID

--- 4 Find the names of pets along with their owners names and the details of the  procedures they have undergone.  

SELECT petowners.name AS owner_name, pets.name AS pet_name, procedureshistory.ProcedureType
FROM petowners
JOIN pets ON petowners.OwnerID = pets.OwnerID
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID;


--- 5 List all pet owners and the number of dogs they own

SELECT petowners.`name`,
COUNT(pets.PetID) AS num_DOG
FROM petowners
LEFT JOIN pets ON petowners.OwnerID= pets.OwnerID AND pets.Kind ='Dog'
GROUP BY petowners.name;

---- 6 Identify pets that have not had any procedures.
SELECT pets.`name` as pet_name, procedureshistory.ProcedureType AS procedure_Type
FROM pets
LEFT JOIN procedureshistory on pets.PetID = procedureshistory.PetID
WHERE procedureshistory.PetID is null;

--- 7 Find the name of the oldest pet.

SELECT `name` AS Odlest_Pet, Age AS Oldest_Age, Kind
FROM pets
WHERE Age = (SELECT MAX(Age) FROM pets);

--- 8 List all pets who had procedures that cost more than the average cost of all procedures.

SELECT pets.name AS pet_name, petowners.name AS owner_name, proceduresdetails.Price AS Procedure_Price
FROM pets
JOIN petowners ON pets.OwnerID = petowners.OwnerID
JOIN procedureshistory ON pets.PetID= procedureshistory.PetID
JOIN proceduresdetails ON procedureshistory.ProcedureSubCode= proceduresdetails.ProcedureSubCode
WHERE proceduresdetails.Price > (
  SELECT AVG(Price) FROM proceduresdetails
);

--- 9 Find the details of procedures performed on 'Cuddles'.

SELECT pets.`name` AS pet_name, procedureshistory.ProcedureType AS Procedure_Type
FROM pets
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
WHERE pets.`name` = 'Cuddles';


--- 10. Create a list of pet owners along with the total cost they have spent on procedures and display only those who have spent above the average spending.

SELECT petowners.OwnerID, petowners.`name` AS owner_name, SUM(proceduresdetails.Price) AS total_spending
FROM petowners
JOIN pets ON petowners.OwnerID = pets.OwnerID
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
JOIN proceduresdetails ON procedureshistory.ProcedureSubCode = proceduresdetails.ProcedureSubCode
GROUP BY petowners.OwnerID, petowners.`name`
HAVING total_spending > (
  SELECT AVG(total_spending)
  FROM (
    SELECT petowners.OwnerID, SUM(proceduresdetails.Price) AS total_spending
    FROM petowners
    JOIN pets ON petowners.OwnerID = pets.OwnerID
    JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
    JOIN proceduresdetails ON procedureshistory.ProcedureSubCode = proceduresdetails.ProcedureSubCode
    GROUP BY petowners.OwnerID
  ) AS average_spending
);

--- 11.List the pets who have undergone a procedure called 'VACCINATIONS'.

SELECT pets.`name` AS pet_name, procedureshistory.ProcedureType
FROM pets
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
WHERE ProcedureType = 'VACCINATIONS'
ORDER BY pets.`Name` DESC 

--- 12.Find the owners of pets who have had a procedure called 'EMERGENCY'.

SELECT petowners.`name` AS owner_name, pets.`name` AS pet_name, procedureshistory.ProcedureType AS Procedure_Type
FROM petowners
JOIN pets ON petowners.OwnerID = pets.OwnerID
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
WHERE ProcedureType = 'EMERGENCY'
ORDER BY petowners.`Name` DESC 

--- 13.Calculate the total cost spent by each pet owner on procedures.

SELECT petowners.OwnerID, petowners.`name` AS owner_name, 
SUM(proceduresdetails.Price) AS total_spending
FROM petowners
JOIN pets ON petowners.OwnerID = pets.OwnerID
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
JOIN proceduresdetails ON procedureshistory.ProcedureSubCode = proceduresdetails.ProcedureSubCode
GROUP BY petowners.OwnerID, petowners.`name`

--- 14.Count the number of pets of each kind.

SELECT Kind, 
COUNT(*) AS Count_Kind
FROM pets
GROUP BY Kind;

--- 15.Group pets by their kind and gender and count the number of pets in each group.

SELECT Kind, 
COUNT(*) AS Count_Kind
FROM pets
GROUP BY Kind;

--- 16.Show the average age of pets for each kind, but only for kinds that have more than 5 pets.

SELECT pets.Kind, AVG(Age)
FROM pets
GROUP BY Kind
HAVING COUNT(*) >5;

--- 17.Find the types of procedures that have an average cost greater than $50.

SELECT ProcedureType,AVG(Price)
FROM proceduresdetails
GROUP BY ProcedureType
HAVING AVG(Price) > 50;

-- 18.Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then 3 Young, Age between 3and 8 Adult, else Senior.

SELECT 'name', Age,
CASE
  WHEN Age < 3 THEN 'Young'
  WHEN Age =3 AND Age <= 8 THEN 'Adult'
  ELSE 'Senior'
END AS Age_category
FROM Pets;

--- 19.Calculate the total spending of each pet owner on procedures, labeling them as 'Low Spender' for spending under $100, 'Moderate Spender' for spending between $100 and $500, and 'High Spender' for spending over $500.

SELECT petowners.`name` AS owner_name, 
   SUM(proceduresdetails.Price) AS total_spending,
   CASE
           WHEN SUM(proceduresdetails.Price) < 100 THEN 'Low Spender'
           WHEN SUM(proceduresdetails.Price) >= 100 AND SUM(proceduresdetails.Price) <= 500 THEN 'Moderate Spender'
           ELSE 'High Spender'
       END AS spending_category
FROM petowners
JOIN pets ON petowners.OwnerID = pets.OwnerID
JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
JOIN proceduresdetails ON procedureshistory.ProcedureSubCode = proceduresdetails.ProcedureSubCode
GROUP BY petowners.`name`;

--- 20.Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).

SELECT Gender,
CASE
    WHEN Gender = 'male' THEN 'Boy'
    WHEN Gender = 'female' THEN 'Girl'
	ELSE 'Unknown'
END AS custom_lable
FROM pets;

--- 21.For each pet, display the pet's name, the number of procedures they've had, and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 procedures, and 'Super User' for more than 7 procedures.

SELECT pets.`name`,
       COUNT(ProcedureType) AS num_procedures,
       CASE
           WHEN COUNT(ProcedureType) BETWEEN 1 AND 3 THEN 'Regular'
           WHEN COUNT(ProcedureType) BETWEEN 4 AND 7 THEN 'Frequent'
           WHEN COUNT(ProcedureType) > 7 THEN 'Super User'
           ELSE 'No procedures'
       END AS status_label
FROM pets
LEFT JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
GROUP BY pets.`name`;

--- 22.Rank pets by age within each kind.

SELECT `name`,Age,
RANK() OVER (ORDER BY Age) AS Rank_PetsbyAge
From pets;

--- 23.Assign a dense rank to pets based on their age, regardless of kind.

SELECT `name`,Age,
DENSE_RANK() OVER (ORDER BY Age) AS Rank_PetsbyAge
From pets;

--- 24.For each pet, show the name of the next and previous pet in alphabetical order.

SELECT `name`,
    LAG(`name`) OVER (ORDER BY `name`) AS previous_pet,
    LEAD(`name`) OVER (ORDER BY `name`) AS next_pet
FROM pets
ORDER BY `name`;  

--- 25.Show the average age of pets, partitioned by their kind.

SELECT Kind,
AVG(Age) Over ( PARTITION BY Kind) As average_age
FROM pets;

-- 26.Create a CTE that lists all pets, then select pets older than 5 years from the CTE.

WITH all_pets AS(SELECT * FROM pets
)
SELECT *
FROM all_pets
WHERE Age>5;





   



