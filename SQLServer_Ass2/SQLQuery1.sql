CREATE TABLE EMPLOYEE(
    Employee_id INT PRIMARY KEY,
    Employee_FName NVARCHAR(50) NOT NULL,
    Employee_LName NVARCHAR(50) NOT NULL,
    Employee_birth DATE NULL,
    Employee_gender CHAR(1) NULL CHECK (Employee_gender IN ('M', 'F', 'O')),
    position NVARCHAR(50) NULL,
    B_code VARCHAR(10),

    CONSTRAINT FK_Employee_Branch
        FOREIGN KEY (B_code)
        REFERENCES BRANCH(B_code) 
);
CREATE TABLE EMPLOYEE_PHONE (
    Employee_id INT NOT NULL,
    Phone_number VARCHAR(15) NOT NULL,
    
    CONSTRAINT PK_Employee_Phone PRIMARY KEY (Employee_id, Phone_number),
    CONSTRAINT FK_Employee_Phone_Employee 
        FOREIGN KEY (Employee_id) 
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE 
);
CREATE TABLE MANAGER (
    Employee_id INT PRIMARY KEY,
    degree NVARCHAR(100) NULL, 
    CONSTRAINT FK_MANAGER_EMPLOYEE 
        FOREIGN KEY (Employee_id) 
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE 
);