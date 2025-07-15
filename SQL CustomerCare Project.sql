-- Create Database
DROP DATABASE IF EXISTS customer_care;
CREATE DATABASE customer_care;
USE customer_care;

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    district VARCHAR(50)
);

-- Create Support Agents Table
CREATE TABLE support_agents (
    agent_id INT PRIMARY KEY,
    name VARCHAR(100),
    team VARCHAR(50)
);

-- Create Tickets Table
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    agent_id INT,
    issue_type VARCHAR(50),
    status VARCHAR(20),
    created_date DATE,
    resolved_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES support_agents(agent_id)
);

-- Insert Customers (South Tamil Nadu)
INSERT INTO customers VALUES
(1, 'Kannan M', 'kannan@gmail.com', 'Madurai'),
(2, 'Revathi S', 'revathi@gmail.com', 'Tirunelveli'),
(3, 'Murugan K', 'murugan@gmail.com', 'Thoothukudi'),
(4, 'Bhuvana L', 'bhuvana@gmail.com', 'Dindigul'),
(5, 'Senthil Raj', 'senthil@gmail.com', 'Theni'),
(6, 'Kavitha P', 'kavitha@gmail.com', 'Virudhunagar');

-- Insert Support Agents
INSERT INTO support_agents VALUES
(1, 'Ramesh T', 'Technical'),
(2, 'Anitha M', 'Billing'),
(3, 'Suresh V', 'General');

-- Insert Tickets
INSERT INTO tickets VALUES
(1, 1, 1, 'Technical', 'Resolved', '2025-07-01', '2025-07-03'),
(2, 2, 2, 'Billing', 'Pending', '2025-07-05', NULL),
(3, 3, 1, 'Technical', 'Resolved', '2025-07-06', '2025-07-07'),
(4, 4, 3, 'General Inquiry', 'Open', '2025-07-10', NULL),
(5, 5, 2, 'Billing', 'Resolved', '2025-07-08', '2025-07-09'),
(6, 6, 3, 'General Inquiry', 'Resolved', '2025-07-04', '2025-07-05');

-- Show all tickets with customer and agent names
SELECT t.ticket_id, c.name AS customer, a.name AS agent, t.issue_type, t.status
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
JOIN support_agents a ON t.agent_id = a.agent_id;

-- Number of tickets per district
SELECT c.district, COUNT(*) AS total_tickets
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.district;

-- Resolved tickets per agent
SELECT a.name AS agent_name, COUNT(*) AS resolved_tickets
FROM tickets t
JOIN support_agents a ON t.agent_id = a.agent_id
WHERE t.status = 'Resolved'
GROUP BY a.name;

-- Customers with unresolved tickets
SELECT c.name, t.status
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.status != 'Resolved';

