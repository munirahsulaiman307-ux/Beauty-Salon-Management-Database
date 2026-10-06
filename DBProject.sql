DROP DATABASE BeautySalonDB;
CREATE DATABASE BeautySalonDB;
USE BeautySalonDB;
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100)
);
INSERT INTO Customer VALUES
(1, 'Furina','0555551234', 'sir7@gmail.com'),
(2, 'raiden', '0562223344', 'sav@gmail.com'),
(3, 'mavuika','0573334455', 'vemis@gmail.com'),
(4, 'Layla','0584445566', 'shaislepy@GMAIL.COM');
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    Phone VARCHAR(15)
);
INSERT INTO Employee VALUES
(11, 'rozaria','Hair dresser', '0533333333'),
(12, 'eula', 'nail tech', '059999999'),
(13, 'jean','massage', '05777777777'),
(14, 'nilou','makeup tech', '05777772222'),
(15, 'varka','Cashier', '05555555555');
     
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2)  CHECK (Price > 0),
    Duration INT CHECK (Duration > 0)
);
INSERT INTO Service VALUES
(1, 'Pretty nails', 200, 2),
(2,'flawless hair', 150, 3),
(3,    'massage'  , 280, 2),
(4,   'makeup'    , 200, 1);
-- Then run your CREATE TABLE and INSERT statements again.
CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Scheduled','Completed','Cancelled')),
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

INSERT INTO Appointment (AppointmentID, Date, Time, Status, CustomerID, EmployeeID) 
VALUES
(85, '2026-02-14', '12:00:00', 'Completed', 1, 14),
(90, '2026-03-16', '09:00:00', 'Cancelled', 2, 12),
(97, '2026-04-16', '18:00:00', 'Scheduled', 3, 13),
(98, '2026-04-17', '19:00:00', 'Completed', 4, 11);

CREATE TABLE Appointment_Service (
    AppointmentID INT,
    ServiceID INT,
    PRIMARY KEY (AppointmentID, ServiceID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);
INSERT INTO Appointment_Service VALUES
(85, 4),
(90, 1),
(97, 3),
(98, 2);
SELECT Date, Time, Status
FROM Appointment
WHERE Status = 'Completed';

SELECT MIN(Price) FROM Service;
SELECT MAX(Price) FROM Service;

SELECT 
    Customer.Name AS CustomerName,
    Employee.Name AS EmployeeName,
    Appointment.Date,
    Appointment.Time,
    Appointment.Status
FROM Appointment
JOIN Customer 
ON Appointment.CustomerID = Customer.CustomerID
JOIN Employee 
ON Appointment.EmployeeID = Employee.EmployeeID;


SELECT Name
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Appointment
    WHERE Status = 'Completed'
);
CREATE VIEW AppointmentReport AS
SELECT 
    c.Name AS CustomerName,
    e.Name AS EmployeeName,
    s.ServiceName,
    s.Price,
    a.Date,
    a.Time,
    a.Status
FROM Appointment a
JOIN Customer c 
    ON a.CustomerID = c.CustomerID
JOIN Employee e 
    ON a.EmployeeID = e.EmployeeID
JOIN Appointment_Service aps 
    ON a.AppointmentID = aps.AppointmentID
JOIN Service s 
    ON aps.ServiceID = s.ServiceID;
    SELECT * FROM AppointmentReport;