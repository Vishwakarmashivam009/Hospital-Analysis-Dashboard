create database hospital_analysis;
use hospital_analysis; 

--Patient Table--
CREATE TABLE Patients(
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(20),
    date_of_birth DATE,
    registration_date DATE,
    insurance_provider VARCHAR(100)
);

select* from [hospital_analysis].[dbo].[patients.csv];

--Business query-1--
SELECT COUNT(*) AS TotalPatients
FROM [hospital_analysis].[dbo].[patients.csv]; 

--removing null column from table--
alter table [hospital_analysis].[dbo].[patients.csv]
drop column column12,column13;

--Doctor table--
CREATE TABLE Doctors(
    doctor_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    specialization VARCHAR(100),
    years_experience INT,
    hospital_branch VARCHAR(100)
); 


-- business query _2
SELECT COUNT(*) AS TotalDoctors
FROM [hospital_analysis].[dbo].[doctors.csv] ;

--remove null column from table--
alter table [hospital_analysis].[dbo].[doctors.csv]
drop column column9,column10;

select* from [hospital_analysis].[dbo].[doctors.csv];
--create doctor exprience column--
ALTER TABLE [hospital_analysis].[dbo].[doctors.csv]
ADD Experience_Category VARCHAR(20);

UPDATE [hospital_analysis].[dbo].[doctors.csv]
SET Experience_Category =
CASE
    WHEN years_experience < 5 THEN 'Junior'
    WHEN years_experience BETWEEN 5 AND 14 THEN 'Mid-Level'
    ELSE 'Senior'
END;




--appointment table--
CREATE TABLE Appointments(
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(50)
); 


select * from [hospital_analysis].[dbo].[Appointments.csv];
--business query---
SELECT status,
       COUNT(*) TotalAppointments
FROM [hospital_analysis].[dbo].[Appointments.csv]
GROUP BY status;
--create appointmets month column-- 
ALTER TABLE [hospital_analysis].[dbo].[Appointments.csv]
ADD Appointment_Month VARCHAR(20); 
--create visite day column--
ALTER TABLE [hospital_analysis].[dbo].[Appointments.csv]
ADD Visit_Day_Type VARCHAR(20);

UPDATE [hospital_analysis].[dbo].[Appointments.csv]
SET Visit_Day_Type =
CASE
    WHEN DATENAME(WEEKDAY, appointment_date) IN ('Saturday','Sunday')
    THEN 'Weekend'
    ELSE 'Weekday'
END;


UPDATE [hospital_analysis].[dbo].[Appointments.csv]
SET Appointment_Month = DATENAME(MONTH, appointment_date);

--create appointment quater column--
ALTER TABLE [hospital_analysis].[dbo].[Appointments.csv]
ADD Appointment_Quarter VARCHAR(5);

UPDATE [hospital_analysis].[dbo].[Appointments.csv]
SET Appointment_Quarter =
'Q' + CAST(DATEPART(QUARTER, appointment_date) AS VARCHAR(1));


--treatment table--
CREATE TABLE Treatments(
    treatment_id INT PRIMARY KEY,
    patient_id INT,
    treatment_type VARCHAR(100),
    cost DECIMAL(10,2)
);
 
 select * from [hospital_analysis].[dbo].[Treatments.csv];


--blling table--
CREATE TABLE Billing(
    bill_id INT PRIMARY KEY,
    patient_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50)
); 

-- create a revenue category column--
ALTER TABLE [hospital_analysis].[dbo].[Billing.csv]
ADD Revenue_Category VARCHAR(20);

UPDATE [hospital_analysis].[dbo].[Billing.csv]
SET Revenue_Category =
CASE
    WHEN amount < 3000 THEN 'Low Revenue'
    WHEN amount < 7000 THEN 'Medium Revenue'
    ELSE 'High Revenue'
END;

select * from [hospital_analysis].[dbo].[Billing.csv];

---business query_3--
SELECT SUM(amount) AS TotalRevenue
FROM [hospital_analysis].[dbo].[Billing.csv];

--create payment flag column--
ALTER TABLE [hospital_analysis].[dbo].[Billing.csv]
ADD Payment_Flag INT;

UPDATE [hospital_analysis].[dbo].[Billing.csv]
SET Payment_Flag =
CASE
    WHEN payment_status = 'Paid' THEN 1
    ELSE 0
END;