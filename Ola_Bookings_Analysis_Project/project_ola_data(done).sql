CREATE Database OLA;
USE OLA;

#1. Get all the successful Bookings
CREATE VIEW Successful_Bookings AS  -- helps to create a view which can run a single line command to generate data entries.
SELECT * FROM bookings
WHERE Booking_Status = 'Success';

SELECT * FROM Successful_Bookings;

#2.#Avg Ride Distance for each vehicle type
CREATE VIEW Average_Ride_Dist_per_Vehicle AS 
SELECT AVG(Ride_Distance) AS 'Average Ride Distance', Vehicle_Type AS 'Vehicle Type'
FROM bookings
GROUP BY Vehicle_Type
ORDER BY 1;

SELECT * FROM Average_Ride_Dist_per_Vehicle;

# 3.Total number of cancelled rides by customers
CREATE VIEW Number_of_Rides_Cancelled_by_Customer AS
SELECT COUNT(customer_ID) AS 'Number of Rides Cancelled by Customer'
FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

SELECT * FROM Number_of_Rides_Cancelled_by_Customer;

# 4. Top 5 customers 
CREATE VIEW top_5_customers AS
SELECT Customer_ID, COUNT(Booking_ID) as total_rides
FROM bookings
GROUP BY Customer_ID
ORDER BY total_rides DESC LIMIT 5;

SELECT * FROM top_5_customers;

#5. Get the number of rides cancelled by drivers due to personal and car-related issues:
CREATE VIEW number_of_rides_cancelled_by_drivers AS
SELECT COUNT(*) 
FROM bookings
WHERE Canceled_Rides_by_Driver LIKE 'Personal%';

SELECT * FROM number_of_rides_cancelled_by_drivers;

#6.Find the maximum and minimum driver ratings for Prime Sedan bookings:
CREATE VIEW Max_min_ratings AS
SELECT MAX(Driver_Ratings) AS 'highest rating', MIN(Driver_Ratings) AS 'lowest rating' 
FROM bookings 
WHERE Vehicle_Type = 'Prime Sedan';

SELECT * FROM Max_min_ratings;

-- 7. Retrieve all rides where payment was made using UPI:
CREATE VIEW payment_upi AS
SELECT * 
FROM bookings
WHERE Payment_Method = 'UPI';

SELECT * FROM payment_upi;

# 8. Find the average customer rating per vehicle type:
CREATE VIEW average_customer_rating_per_vehicle_type AS 
SELECT AVG(Customer_Rating) AS 'Average Customer Rating', Vehicle_Type AS 'Vehicle Type'
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM average_customer_rating_per_vehicle_type;

# 9. Calculate the total booking value of rides completed successfully, and arrange them in ascending order according to various vehicular types:
CREATE VIEW total_booking_value_of_rides_completed_successfully AS
SELECT SUM(Booking_Value) AS 'Sum of Booking Value', Vehicle_type AS'Vehicle Type'
FROM Bookings
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type
ORDER BY 'Sum of Booking Value';

SELECT * FROM total_booking_value_of_rides_completed_successfully;

# 10. List all incomplete rides along with the reason:
CREATE VIEW incomplete_rides_along_with_the_reason AS
SELECT Booking_ID, Incomplete_Rides_Reason 
FROM bookings
WHERE Incomplete_Rides = 'Yes';

SELECT * FROM incomplete_rides_along_with_the_reason;
