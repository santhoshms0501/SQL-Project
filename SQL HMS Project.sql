create database HealthCareManagement;
use HealthCareManagement;

-- Drop tables if they already exist (for re-run convenience)
DROP TABLE IF EXISTS Billing, MedicalRecords, Appointments, Doctors, Patients, Departments;

-- Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);

-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE,
    phone VARCHAR(15),
    address TEXT
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    specialization VARCHAR(100),
    department_id INT,
    phone VARCHAR(15),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status VARCHAR(50),
    reason TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Medical Records Table
CREATE TABLE MedicalRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    diagnosis TEXT,
    prescription TEXT,
    record_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Billing Table
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    amount DECIMAL(10, 2),
    billing_date DATE,
    payment_status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

INSERT INTO Departments (department_name) VALUES
('Cardiology'),
('Neurology'),
('Pediatrics'),
('Orthopedics'),
('General Medicine');

INSERT INTO Doctors (first_name, last_name, specialization, department_id, phone) VALUES
('Arun', 'Kumar', 'Cardiologist', 1, '9003012345'),
('Meena', 'Ravi', 'Neurologist', 2, '9003023456'),
('Karthik', 'Sundar', 'Pediatrician', 3, '9003034567'),
('Divya', 'Balan', 'Orthopedic Surgeon', 4, '9003045678'),
('Ramesh', 'Natarajan', 'General Physician', 5, '9003056789');

INSERT INTO Patients (first_name, last_name, gender, birth_date, phone, address) VALUES
('Lakshmi', 'Subramanian', 'Female', '1989-02-15', '9876512345', '12, North Street, Madurai'),
('Rajesh', 'Murugan', 'Male', '1984-05-22', '9876523456', '45, Gandhi Road, Coimbatore'),
('Anitha', 'Vijay', 'Female', '2002-11-18', '9876534567', '78, Anna Nagar, Chennai'),
('Suresh', 'Kannan', 'Male', '1978-09-10', '9876545678', '33, Trichy Main Road, Salem'),
('Priya', 'Balaji', 'Female', '1995-07-07', '9876556789', '90, Mettupalayam Road, Erode');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, reason) VALUES
(1, 1, '2025-07-01 10:00:00', 'Completed', 'Chest discomfort'),
(2, 2, '2025-07-02 11:30:00', 'Scheduled', 'Frequent headaches'),
(3, 3, '2025-07-03 12:00:00', 'Completed', 'Child fever'),
(4, 4, '2025-07-04 14:30:00', 'Cancelled', 'Leg pain'),
(5, 5, '2025-07-05 16:00:00', 'Completed', 'General checkup');

INSERT INTO MedicalRecords (patient_id, doctor_id, diagnosis, prescription, record_date) VALUES
(1, 1, 'Hypertension', 'Amlodipine 5mg daily', '2025-07-01'),
(2, 2, 'Migraine', 'Sumatriptan 50mg', '2025-07-02'),
(3, 3, 'Viral Fever', 'Paracetamol and hydration', '2025-07-03'),
(5, 5, 'Good Health', 'Vitamin D and iron supplements', '2025-07-05');

INSERT INTO Billing (patient_id, amount, billing_date, payment_status) VALUES
(1, 1200.00, '2025-07-01', 'Paid'),
(2, 800.00, '2025-07-02', 'Unpaid'),
(3, 600.00, '2025-07-03', 'Paid'),
(5, 400.00, '2025-07-05', 'Paid');

-- View Appointment Details
select a.appointment_id, p.first_name as patient_name, d.first_name as doctor_name,
       a.appointment_date, a.status, a.reason
from Appointments a
join Patients p on a.patient_id = p.patient_id
join Doctors d on a.doctor_id = d.doctor_id;

-- List All Patients Who Have Paid Bills
select p.first_name, p.last_name, b.amount, b.billing_date
from Billing b
join Patients p on b.patient_id = p.patient_id
where b.payment_status = 'Paid';

-- Total Billing Amount per Patient
select p.patient_id, p.first_name, p.last_name, SUM(b.amount) as total_billed
from Billing b
join Patients p on b.patient_id = p.patient_id
group by p.patient_id, p.first_name, p.last_name;

-- Count Appointments per Department
select dept.department_name, COUNT(*) as total_appointments
from Appointments a
join Doctors d on a.doctor_id = d.doctor_id
join Departments dept on d.department_id = dept.department_id
group by dept.department_name;

-- Upcoming Appointments This Week
select a.appointment_id, p.first_name, a.appointment_date
from Appointments a
join Patients p on a.patient_id = p.patient_id
where a.appointment_date between CURDATE() and DATE_ADD(CURDATE(), interval 7 day)
order by a.appointment_date;

-- List Doctors and Number of Patients They Treated
select d.first_name as doctor_name, COUNT(Distinct a.patient_id) as total_patients
from Doctors d
left join Appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id, d.first_name;
