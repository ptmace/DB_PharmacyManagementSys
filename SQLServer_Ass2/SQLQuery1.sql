CREATE TABLE EMPLOYEE(
    Employee_id INT PRIMARY KEY,
    Employee_FName NVARCHAR(50) NOT NULL,
    Employee_LName NVARCHAR(50) NOT NULL,
    Employee_birth DATE,
    Employee_gender CHAR(1) CHECK (Employee_gender IN ('M', 'F')),
    Position NVARCHAR(50),
    B_code VARCHAR(10)
);
CREATE TABLE EMPLOYEE_PHONE (
    Employee_id INT NOT NULL,
    Phone_number VARCHAR(15) NOT NULL,
    
    CONSTRAINT PK_EMPLOYEE_PHONE PRIMARY KEY (Employee_id, Phone_number),
    CONSTRAINT FK_EMPLOYEE_PHONE_EMPLOYEE 
        FOREIGN KEY (Employee_id) 
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE 
);
CREATE TABLE MANAGER (
    Employee_id INT PRIMARY KEY,
    Degree NVARCHAR(50) NOT NULL, 
    CONSTRAINT FK_MANAGER_EMPLOYEE 
        FOREIGN KEY (Employee_id) 
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE 
);
CREATE TABLE SALESMAN (
    Employee_id INT PRIMARY KEY,
    CONSTRAINT FK_SALESMAN_EMPLOYEE 
        FOREIGN KEY (Employee_id) 
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE 
);
CREATE TABLE PHARMACIST (
    Employee_id INT PRIMARY KEY,
    Cert NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_PHARMACIST_EMPLOYEE
        FOREIGN KEY (Employee_id)
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE
);
CREATE TABLE CSR (
    Employee_id INT PRIMARY KEY,
    CONSTRAINT FK_CSR_EMPLOYEE
        FOREIGN KEY (Employee_id)
        REFERENCES EMPLOYEE(Employee_id)
        ON DELETE CASCADE
);
CREATE TABLE BRANCH (
    B_code VARCHAR(10) PRIMARY KEY, 
    B_phone VARCHAR(15) NOT NULL UNIQUE, 
    B_name NVARCHAR(100) NOT NULL, 
    Street NVARCHAR(100) NOT NULL, 
    Ward NVARCHAR(50) NOT NULL,
    City NVARCHAR(50) NOT NULL, 
    Employee_id INT,
    
    CONSTRAINT FK_BRANCH_MANAGER
        FOREIGN KEY (Employee_id) 
        REFERENCES MANAGER(Employee_id)
        ON DELETE SET NULL 
);
ALTER TABLE EMPLOYEE
    ADD CONSTRAINT FK_EMPLOYEE_BRANCH
        FOREIGN KEY (B_code)
        REFERENCES BRANCH(B_code)
        ON DELETE SET NULL;




CREATE TABLE PRODUCT (
    Product_id VARCHAR(10) PRIMARY KEY,
    Product_name NVARCHAR(100) NOT NULL,
    Mfg_company NVARCHAR(100) NOT NULL,
    Product_price DECIMAL(18, 2) NOT NULL CHECK (product_price > 0),
    Product_value DECIMAL(18, 2) NOT NULL CHECK (product_value > 0),
    Unit NVARCHAR(20) NOT NULL,
    Expiry_date DATE,
    Description NVARCHAR(MAX),
    
    CONSTRAINT CK_PRODUCT_PRICELOGIC CHECK (Product_price >= Product_value)
	
);

CREATE TABLE PARENT_PRODUCT (
    Product_id VARCHAR(10),       
    Parent_Product_id VARCHAR(10), 
    PRIMARY KEY (Product_id , Parent_Product_id),
    FOREIGN KEY (Product_id ) REFERENCES PRODUCT(Product_id )
	ON DELETE CASCADE,

    FOREIGN KEY (Parent_Product_id) REFERENCES PRODUCT(Product_id ),
    
    CONSTRAINT CK_NOSELFPARENT CHECK (Product_id <> Parent_Product_id)
);


CREATE TABLE MEDICINE (
    Product_id VARCHAR(10) PRIMARY KEY,
    Type NVARCHAR(50),
    Class_drug NVARCHAR(50) NOT NULL,
    Ingredient NVARCHAR(MAX),
    	FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id) 
      	ON DELETE CASCADE,

    	CONSTRAINT CK_CLASSDRUG CHECK (Class_drug IN (N'Kê đơn', N'Không kê đơn'))
);

CREATE TABLE DIETARY_SUPPLEMENT (
    Product_id VARCHAR(10) PRIMARY KEY,
    Target_user NVARCHAR(100),
    Health_benefit NVARCHAR(MAX),
    Ingredient NVARCHAR(MAX),
    	FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id) 
	ON DELETE CASCADE
);

CREATE TABLE EQUIPMENT (
    Product_id VARCHAR(10) PRIMARY KEY,
    Parameters NVARCHAR(MAX),
    	FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id)
	ON DELETE CASCADE
);

CREATE TABLE BRANCH_PRODUCT (
    B_code VARCHAR(10) NOT NULL,    
    Product_id VARCHAR(10) NOT NULL, 
    Quantity_present INT DEFAULT 0 NOT NULL,
    
    PRIMARY KEY (B_code, Product_id),
    FOREIGN KEY (B_code) REFERENCES BRANCH(B_code)
	ON DELETE CASCADE,
    FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id),
    
    CONSTRAINT CK_STOCK_POSITIVE CHECK (Quantity_present >= 0)
);


CREATE TABLE WAREHOUSE (
    Warehouse_id VARCHAR(10) PRIMARY KEY, 
    Warehouse_name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE SUPPLIER (
    Supplier_id VARCHAR(10) PRIMARY KEY,      
    Supplier_name NVARCHAR(200) NOT NULL,      
    Supplier_addr NVARCHAR(255) NOT NULL,       
    Supplier_email NVARCHAR(100) UNIQUE,        
    Tax_code VARCHAR(20) NOT NULL UNIQUE       
);



CREATE TABLE SUPPLY (
    Supplier_id VARCHAR(10) NOT NULL,
    Product_id VARCHAR(10) NOT NULL,
    Warehouse_id VARCHAR(10) NOT NULL,
    Quantity_supply INT NOT NULL CHECK (quantity_supply >= 0),

    CONSTRAINT PK_SUPPLY
        PRIMARY KEY (Supplier_id, Product_id, Warehouse_id),

   CONSTRAINT FK_SUPPLY_SUPPLIER
        FOREIGN KEY (Supplier_id) 
        REFERENCES SUPPLIER(Supplier_id),

    CONSTRAINT FK_SUPPLY_PRODUCT
        FOREIGN KEY (Product_id) 
        REFERENCES PRODUCT(Product_id),
       
    CONSTRAINT FK_SUPPLY_WAREHOUSE
        FOREIGN KEY (Warehouse_id) 
        REFERENCES WAREHOUSE(Warehouse_id) 
        
);
CREATE TABLE SUPPLIER_PHONE (
    Supplier_id VARCHAR(10) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    
    
    CONSTRAINT PK_SUPPLIER_PHONE
        PRIMARY KEY (Supplier_id, Phone),
        
    
    CONSTRAINT FK_SUPPLIER_PHONE_SUPPLIER
        FOREIGN KEY (Supplier_id) 
        REFERENCES SUPPLIER(Supplier_id) 
        ON DELETE CASCADE 
       
);

CREATE TABLE IMPORT_RECEIPT (
    Import_id INT PRIMARY KEY, 
    Import_date DATETIME DEFAULT GETDATE(), 
    Import_total_price DECIMAL(18, 2) DEFAULT 0, 
    Employee_id INT,
    Warehouse_id VARCHAR(10), 
    
    CONSTRAINT FK_IMPORT_EMPLOYEE
        FOREIGN KEY (Employee_id)
        REFERENCES MANAGER(Employee_id)
        ON DELETE SET NULL, 

    CONSTRAINT FK_IMPORT_WAREHOUSE
        FOREIGN KEY (Warehouse_id)
        REFERENCES WAREHOUSE(Warehouse_id)
        ON DELETE SET NULL
);
CREATE TABLE IMPORT_DETAIL (
    Import_id INT NOT NULL,
    Import_ornum INT NOT NULL,
    Quantity_import INT CHECK (quantity_import > 0), 
    Product_id VARCHAR(10) NOT NULL, 

    CONSTRAINT PK_IMPORT_DETAIL PRIMARY KEY (Import_id, Import_ornum),

    CONSTRAINT FK_DETAIL_RECEIPT
        FOREIGN KEY (Import_id)
        REFERENCES IMPORT_RECEIPT(Import_id)
        ON DELETE CASCADE,


    CONSTRAINT FK_DETAIL_PRODUCT
        FOREIGN KEY (Product_id)
        REFERENCES PRODUCT(Product_id)
);

CREATE TABLE CUSTOMER (
    Customer_id VARCHAR(10) PRIMARY KEY,      
    Fname NVARCHAR(50) NOT NULL,               
    Lname NVARCHAR(50) NOT NULL,               
    Customer_addr NVARCHAR(255),               
    Customer_birth DATE,                      
    Customer_gender CHAR(1) CHECK (Customer_gender IN ('M', 'F')),            
    Accumulated_points DECIMAL(10, 2) NOT NULL DEFAULT 0      
        CHECK (Accumulated_points >= 0),
    Customer_rank NVARCHAR(20) DEFAULT 'Standard' CHECK (Customer_rank IN ('Standard', 'Silver', 'Gold', 'Diamond'))    
);

CREATE TABLE CUSTOMER_PHONE (
    Customer_id VARCHAR(10) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE, 
   
    CONSTRAINT PK_CUSTOMER_PHONE
        PRIMARY KEY (Customer_id, Phone),
    
    CONSTRAINT FK_CUSTOMER_PHONE_CUSTOMER
        FOREIGN KEY (Customer_id) 
        REFERENCES CUSTOMER(Customer_id) 
        ON DELETE CASCADE 
        
);

CREATE TABLE PHARM_CUSTOMER (
    Customer_id VARCHAR(10), 
    Datetime DATETIME2,        
    Employee_id INT,                  

    CONSTRAINT PK_CUSTOMER_PHARMACIST
    PRIMARY KEY (Customer_id, Employee_id, Datetime),

    CONSTRAINT FK_PHARMACIST_ADVISIOR
    FOREIGN KEY (Employee_id) 
        REFERENCES PHARMACIST(Employee_id) 
        ON DELETE CASCADE,
    CONSTRAINT FK_CUSTOMER_ADVISEE
    FOREIGN KEY (Customer_id) 
        REFERENCES CUSTOMER(Customer_id) 
        ON DELETE CASCADE       
);


CREATE TABLE INVOICE (
    Invoice_id VARCHAR(10) PRIMARY KEY,
    Invoice_date DATE DEFAULT GETDATE() NOT NULL,
    Invoice_total_price DECIMAL(18, 2) DEFAULT 0 NOT NULL,
    Employee_id INT, 
    Customer_id VARCHAR(10),
    	FOREIGN KEY (Employee_id) REFERENCES SALESMAN(Employee_id)
ON DELETE SET NULL,
    	FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id)
	ON DELETE SET NULL,
	CONSTRAINT CK_INVOICE_TOTAL CHECK (invoice_total_price >= 0)
);

CREATE TABLE INVOICE_DETAIL (
    Invoice_id VARCHAR(10) NOT NULL,
    Invoice_ornum INT NOT NULL,
    Quantity_sales INT NOT NULL,
    Product_id VARCHAR(10)  NOT NULL,
    PRIMARY KEY (Invoice_id, Invoice_ornum),
    	FOREIGN KEY (Invoice_id) REFERENCES INVOICE(Invoice_id)
ON DELETE CASCADE,

    	FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id),

	CONSTRAINT CK_SALES_QTY CHECK (quantity_sales > 0)
);

CREATE TABLE FEEDBACK (
    Feedback_id VARCHAR(15) PRIMARY KEY,      
    Feedback_content NVARCHAR(100) NOT NULL,            
    Feedback_date DATETIME NOT NULL,          
    Invoice_id VARCHAR(10),                   
    Customer_id VARCHAR(10) NOT NULL,         
    Employee_id INT,                   

    CONSTRAINT FK_FEEDBACK_INVOICE
        FOREIGN KEY (Invoice_id) 
        REFERENCES INVOICE(Invoice_id)
        ON DELETE SET NULL,
      
    CONSTRAINT FK_FEEDBACK_CUSTOMER   
        FOREIGN KEY (Customer_id) 
        REFERENCES CUSTOMER(Customer_id)
        ON DELETE CASCADE, 
                
    CONSTRAINT FK_FEEDBACK_EMPLOYEE    
        FOREIGN KEY (Employee_id) 
        REFERENCES CSR(Employee_id) 
        ON DELETE SET NULL 
       
);

GO

INSERT INTO PRODUCT (Product_id, Product_name, Mfg_company, Product_price, Product_value, Unit, Expiry_date, Description) VALUES
('P001', N'Paracetamol 500mg', N'OPV Pharma', 15000.00, 12000.00, N'Hộp', '2026-10-01', N'Giảm đau, hạ sốt'),
('P002', N'Siro Ho', N'Traphaco', 45000.00, 35000.00, N'Chai', '2027-05-20', N'Điều trị ho khan, ho có đờm'),
('P003', N'Băng gạc y tế', N'3M', 20000.00, 18000.00, N'Túi', '2028-01-01', N'Bảo vệ vết thương'),
('P004', N'Vitamin C 1000mg', N'DHG Pharma', 90000.00, 75000.00, N'Hộp', '2026-12-31', N'Bổ sung Vitamin C'),
('P005', N'Máy đo huyết áp', N'Omron', 950000.00, 800000.00, N'Chiếc', NULL, N'Máy đo huyết áp điện tử'),
('P006', N'Thuốc đau dạ dày', N'AstraZeneca', 120000.00, 100000.00, N'Vỉ', '2027-08-15', N'Điều trị loét dạ dày'),
('P007', N'Thuốc nhỏ mắt V-Rohto', N'Rohto', 40000.00, 32000.00, N'Chai', '2028-01-01', N'Giảm mỏi mắt'),
('P008', N'Khẩu trang y tế cao cấp', N'3M', 80000.00, 65000.00, N'Hộp', NULL, N'Bảo vệ hô hấp'),
('P009', N'Omega 3-6-9', N'Blackmores', 350000.00, 290000.00, N'Lọ', '2027-04-01', N'Bổ sung Omega'),
('P010', N'Thiết bị xông mũi', N'Omron', 600000.00, 480000.00, N'Chiếc', NULL, N'Điều trị hô hấp'),
('P011', N'Bông y tế vô trùng', N'Bông Bạch Tuyết', 15000.00, 10000.00, N'Gói', '2028-12-31', N'Vệ sinh vết thương'),
('P012', N'Thuốc cảm cúm', N'Traphaco', 25000.00, 20000.00, N'Vỉ', '2026-09-01', N'Giảm triệu chứng cảm cúm'),
('P013', N'Sữa non Colostrum', N'VitaDairy', 450000.00, 380000.00, N'Hộp', '2027-02-01', N'Tăng cường miễn dịch'),
('P014', N'Kim tiêm insulin', N'Becton', 3000.00, 2500.00, N'Cái', '2028-05-01', N'Dụng cụ y tế'),
('P015', N'Kem bôi ngoài da', N'Dermatology', 60000.00, 48000.00, N'Tuýp', '2027-10-10', N'Điều trị da liễu'),
('P016', N'Dầu gội trị gàu', N'Selsun', 150000.00, 120000.00, N'Chai', '2028-03-01', N'Mỹ phẩm đặc trị'),
('P017', N'Túi chườm nóng lạnh', N'Medihand', 120000.00, 95000.00, N'Túi', NULL, N'Giảm đau vật lý trị liệu'),
('P018', N'Bổ gan Liver X', N'Korean Ginseng', 280000.00, 220000.00, N'Lọ', '2027-11-01', N'Hỗ trợ chức năng gan');


INSERT INTO MEDICINE (Product_id, Type, Class_drug, Ingredient) VALUES
('P001', N'Thuốc viên', N'Không kê đơn', N'Paracetamol'),
('P002', N'Siro', N'Không kê đơn', N'Mật ong, chanh'),
('P006', N'Thuốc viên', N'Kê đơn', N'Omeprazole'),
('P007', N'Thuốc nhỏ mắt', N'Không kê đơn', N'Tetrahydrozoline'),
('P012', N'Thuốc viên', N'Không kê đơn', N'Paracetamol, Phenylephrine'),
('P015', N'Kem bôi', N'Kê đơn', N'Hydrocortisone');


INSERT INTO DIETARY_SUPPLEMENT (Product_id, Target_user, Health_benefit, Ingredient) VALUES
('P004', N'Người lớn', N'Tăng cường miễn dịch', N'Vitamin C'),
('P009', N'Người lớn', N'Hỗ trợ tim mạch', N'Omega 3, 6, 9'),
('P013', N'Trẻ em', N'Tăng cường miễn dịch', N'Sữa non, IgG'),
('P016', N'Mọi đối tượng', N'Điều trị gàu', N'Selenium Sulfide'),
('P018', N'Người lớn', N'Hỗ trợ chức năng gan', N'Cà gai leo, Actiso'),
('P003', N'Mọi đối tượng', N'Vệ sinh da', N'Cotton, gạc'); 


INSERT INTO EQUIPMENT (Product_id, Parameters) VALUES
('P005', N'Điện tử, đo cổ tay'),
('P008', N'N95, 4 lớp'),
('P010', N'Công nghệ sóng siêu âm'),
('P011', N'Bông không dệt'), 
('P014', N'Đầu kim 30G'),
('P017', N'Vật lý trị liệu, Gel');


INSERT INTO PARENT_PRODUCT (Product_id, Parent_Product_id) VALUES
('P001', 'P002'), ('P004', 'P005'), ('P006', 'P005'),
('P001', 'P006'), ('P004', 'P001'), ('P006', 'P004');

INSERT INTO WAREHOUSE (Warehouse_id, Warehouse_name) VALUES
('W001', N'Kho Tổng Miền Nam'),
('W002', N'Kho Tổng Miền Bắc'),
('W003', N'Kho Đà Nẵng'),
('W004', N'Kho Cần Thơ'),
('W005', N'Kho Hải Phòng'),
('W006', N'Kho Hải Châu');


INSERT INTO SUPPLIER (Supplier_id, Supplier_name, Supplier_addr, Supplier_email, Tax_code) VALUES
('S001', N'Công ty Dược phẩm An Khang', N'10 Đinh Tiên Hoàng, Hà Nội', 'duocphamx@mail.com', '0100000001'),
('S002', N'Thiết bị Y tế Minh Tâm', N'25 Hai Bà Trưng, TP.HCM', 'tbytez@mail.com', '0100000002'),
('S003', N'Dược phẩm Trung Ương', N'50 Trần Phú, Đà Nẵng', 'dp_tu@mail.com', '0100000003'),
('S004', N'Công ty TNHH Việt Nam Pharma', N'12 Nguyễn Huệ, Cần Thơ', 'ctyh@mail.com', '0100000004'),
('S005', N'Cty Dinh dưỡng HealthyLife', N'33 Phan Đình Phùng, Hải Phòng', 'dd_v@mail.com', '0100000005'),
('S006', N'Cty Thiết bị TechMed', N'88 Lê Duẩn, Huế', 'tb_w@mail.com', '0100000006');


INSERT INTO SUPPLIER_PHONE (Supplier_id, Phone) VALUES
('S001', '0981112221'), ('S002', '0973334442'),
('S003', '0965556663'), ('S004', '0957778884'),
('S005', '0949990005'), ('S006', '0930001116');

INSERT INTO EMPLOYEE (Employee_id, Employee_FName, Employee_LName, Employee_birth, Employee_gender, Position, B_code) VALUES
(101, N'Phạm', N'Thị Mai Anh', '1985-09-23', 'M', N'Manager', NULL),
(102, N'Trương', N'Thị Hòa Hảo', '1990-10-04', 'F', N'Manager', NULL),
(103, N'Nguyễn', N'Hữu An Lợi', '1988-12-14', 'M', N'Manager', NULL),
(104, N'Đặng', N'Hồng Nhung', '1992-03-10', 'F', N'Manager', NULL),
(105, N'Hồ', N'Quang Minh', '1987-01-01', 'M', N'Manager', NULL),
(106, N'Trịnh', N'Ngọc Ánh', '1995-07-07', 'F', N'Manager', NULL);

INSERT INTO MANAGER (Employee_id, Degree) VALUES
(101, N'Thạc sĩ Quản trị Kinh doanh'), (102, N'Cử nhân Kinh tế'),
(103, N'Thạc sĩ Dược học'), (104, N'Cử nhân Quản lý'),
(105, N'Thạc sĩ Tài chính'), (106, N'Cử nhân Kế toán');

INSERT INTO BRANCH (B_code, B_phone, B_name, Street, Ward, City, Employee_id) VALUES
('B001', '0281234567', N'CN Nguyễn Văn Cừ', N'123 Nguyễn Văn Cừ', N'P4', N'TP.HCM', 101),
('B002', '0249876543', N'CN Hoàng Quốc Việt', N'45 Hoàng Quốc Việt', N'P1', N'Hà Nội', 102),
('B003', '0511223344', N'CN Lê Lợi', N'67 Lê Lợi', N'Hải Châu 1', N'Đà Nẵng', 103),
('B004', '0285556667', N'CN Độc Lập', N'89 Độc Lập', N'P2', N'TP.HCM', 104),
('B005', '0244443332', N'CN Cầu Giấy', N'10 Trần Đăng Ninh', N'Dịch Vọng', N'Hà Nội', 105),
('B006', '0511998877', N'CN Hùng Vương', N'22 Hùng Vương', N'Vĩnh Ninh', N'Huế', 106);

UPDATE EMPLOYEE
SET B_code = B.B_code
FROM BRANCH B
WHERE EMPLOYEE.Employee_id = B.Employee_id
  AND EMPLOYEE.Position = N'Manager';

INSERT INTO EMPLOYEE (Employee_id, Employee_FName, Employee_LName, Employee_birth, Employee_gender, Position, B_code) VALUES
(107, N'Phan', N'Thị Ngọc', '1993-02-14', 'F', N'Pharmacist', 'B001'),
(108, N'Vũ', N'Quốc Hùng', '1998-10-05', 'M', N'Pharmacist', 'B002'),
(109, N'Bùi', N'Thị Linh', '1996-04-22', 'F', N'Salesman', 'B003'),
(110, N'Trịnh', N'Văn Kiên', '1999-06-18', 'M', N'Salesman', 'B004'),
(111, N'Đặng', N'Thị Loan', '1997-12-03', 'F', N'CSR', NULL),
(112, N'Hồ', N'Văn Minh', '1991-09-09', 'M', N'CSR', NULL),
(113, N'Lê', N'Văn Nguyên', '1990-01-01', 'M', N'Pharmacist', 'B001'),
(114, N'Trần', N'Thị Oanh', '1994-05-15', 'F', N'Pharmacist', 'B002'),
(115, N'Ngô', N'Văn Phúc', '1991-07-25', 'M', N'Pharmacist', 'B003'),
(116, N'Đinh', N'Thị Quỳnh', '1995-12-12', 'F', N'Pharmacist', 'B004'),
(117, N'Hoàng', N'Văn Phát', '1997-03-03', 'M', N'Salesman', 'B005'),
(118, N'Võ', N'Thị Sen', '1999-06-06', 'F', N'Salesman', 'B006'),
(119, N'Dương', N'Văn Thanh', '1994-08-18', 'M', N'Salesman', 'B001'),
(120, N'Phan', N'Thị Uyên', '1996-10-20', 'F', N'Salesman', 'B002'),
(121, N'Mai', N'Văn Việt', '1992-04-04', 'M', N'CSR', NULL),
(122, N'Bạch', N'Thị Xuân', '1998-11-11', 'F', N'CSR', NULL),
(123, N'Kỷ', N'Văn Sơn', '1993-02-22', 'M', N'CSR', NULL),
(124, N'Chu', N'Thị Yến', '1997-09-09', 'F', N'CSR', NULL);

INSERT INTO EMPLOYEE_PHONE (Employee_id, Phone_number) VALUES
(101, '0901112233'), (102, '0912223344'), (103, '0923334455'),
(104, '0934445566'), (105, '0945556677'), (106, '0967778899');


INSERT INTO PHARMACIST (Employee_id, Cert) VALUES
(107, N'Chứng chỉ hành nghề Dược loại A'), (108, N'Chứng chỉ hành nghề Dược loại B'),
(113, N'Chứng chỉ hành nghề Dược loại A'), (114, N'Chứng chỉ hành nghề Dược loại B'),
(115, N'Chứng chỉ hành nghề Dược loại A'), (116, N'Chứng chỉ hành nghề Dược loại B');


INSERT INTO SALESMAN (Employee_id) VALUES
(109), (110), (117), (118), (119), (120);


INSERT INTO CSR (Employee_id) VALUES
(111), (112), (121), (122), (123), (124);


INSERT INTO CUSTOMER (Customer_id, Fname, Lname, Customer_addr, Customer_birth, Customer_gender, Accumulated_points, Customer_rank) VALUES
('CUST001', N'Nguyễn', N'Văn Nam', N'1A CMT8, TP.HCM', '1975-01-25', 'M', 150.50, N'Gold'),
('CUST002', N'Trần', N'Thị Phương', N'2B Láng Hạ, Hà Nội', '1982-05-10', 'F', 50.00, N'Silver'),
('CUST003', N'Lê', N'Văn Quang', N'3C Nguyễn Văn Linh, Đà Nẵng', '1995-12-01', 'M', 0.00, N'Standard'),
('CUST004', N'Phạm', N'Thị Hồng', N'4D Võ Văn Tần, TP.HCM', '1968-08-15', 'F', 200.75, N'Gold'),
('CUST005', N'Hoàng', N'Quốc Sơn', N'5E Bà Triệu, Hà Nội', '2000-03-30', 'M', 10.25, N'Standard'),
('CUST006', N'Đỗ', N'Thị Thúy', N'6F Hùng Vương, Huế', '1993-11-11', 'F', 0.00, N'Standard');

INSERT INTO CUSTOMER_PHONE (Customer_id, Phone) VALUES
('CUST001', '0908123456'), ('CUST002', '0919123456'),
('CUST003', '0988123456'), ('CUST004', '0937123456'),
('CUST005', '0977123456'), ('CUST006', '0966123456');

INSERT INTO PHARM_CUSTOMER (Employee_id, Customer_id, Datetime) VALUES
(107, 'CUST001', '2025-11-01 09:00:00'),
(108, 'CUST002', '2025-11-02 10:30:00'),
(113, 'CUST003', '2025-11-02 14:00:00'),
(114, 'CUST004', '2025-11-03 08:45:00'),
(115, 'CUST005', '2025-11-04 11:15:00'), 
(116, 'CUST006', '2025-11-05 15:30:00'); 

INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) VALUES
('INV001', '2025-11-01', 150000.00, 109, 'CUST001'),
('INV002', '2025-11-02', 45000.00, 110, 'CUST002'),
('INV003', '2025-11-02', 90000.00, 117, 'CUST003'),
('INV004', '2025-11-03', 950000.00, 118, 'CUST004'),
('INV005', '2025-11-04', 120000.00, 109, 'CUST005'),
('INV006', '2025-11-05', 20000.00, 110, 'CUST006'),
('INV007', '2025-11-12', 0, 109, 'CUST001');


INSERT INTO INVOICE_DETAIL (Invoice_id, Invoice_ornum, Quantity_sales, Product_id) VALUES
('INV001', 1, 10, 'P001'), ('INV002', 1, 1, 'P002'),
('INV003', 1, 1, 'P004'), ('INV004', 1, 1, 'P005'),
('INV005', 1, 1, 'P006'), ('INV006', 1, 1, 'P003');


INSERT INTO IMPORT_RECEIPT (Import_id, Import_date, Import_total_price, Employee_id, Warehouse_id) VALUES
(1, '2025-10-20', 60000000.00, 101, 'W001'), (2, '2025-10-21', 40000000.00, 102, 'W002'),
(3, '2025-10-22', 30000000.00, 103, 'W003'), (4, '2025-10-23', 24000000.00, 104, 'W004'),
(5, '2025-10-24', 15000000.00, 105, 'W005'), (6, '2025-10-25', 36000000.00, 106, 'W006'),
(7, '2025-11-15', 40000000.00, 101, 'W001'); 


INSERT INTO IMPORT_DETAIL (Import_id, Import_ornum, Quantity_import, Product_id) VALUES
(1, 1, 5000, 'P001'), (2, 1, 50, 'P005'),
(3, 1, 250, 'P004'), (4, 1, 1000, 'P002'),
(5, 1, 500, 'P006'), (6, 1, 100, 'P003');


INSERT INTO BRANCH_PRODUCT (B_code, Product_id, Quantity_present) VALUES
('B001', 'P001', 50), ('B002', 'P002', 30),
('B003', 'P004', 100), ('B004', 'P005', 5),
('B005', 'P006', 40), ('B006', 'P003', 60),
('B003', 'P002', 100), ('B003', 'P018', 2); 


INSERT INTO SUPPLY (Supplier_id, Product_id, Warehouse_id, Quantity_supply) VALUES
('S001', 'P001', 'W001', 5000), ('S002', 'P005', 'W002', 500),
('S003', 'P006', 'W003', 3000), ('S001', 'P004', 'W001', 10000),
('S003', 'P002', 'W004', 2000), ('S002', 'P003', 'W005', 1500);


INSERT INTO FEEDBACK (Feedback_id, Feedback_content, Feedback_date, Invoice_id, Customer_id, Employee_id) VALUES
('FB001', N'Dịch vụ tốt, dược sĩ tư vấn nhiệt tình.', '2025-11-01 10:30:00', 'INV001', 'CUST001', 111),
('FB002', N'Giao hàng nhanh hơn dự kiến.', '2025-11-03 14:00:00', 'INV002', 'CUST002', 112),
('FB003', N'Giá sản phẩm hơi cao so với thị trường.', '2025-11-03 16:30:00', 'INV003', 'CUST003', 121),
('FB004', N'Máy đo huyết áp hoạt động tốt, chất lượng sản phẩm tuyệt vời.', '2025-11-04 09:00:00', 'INV004', 'CUST004', 122),
('FB005', N'Cần cải thiện khâu đóng gói hàng, hộp bị móp nhẹ.', '2025-11-05 11:30:00', 'INV005', 'CUST005', 123),
('FB006', N'Nhân viên bán hàng tư vấn nhiệt tình, thân thiện.', '2025-11-06 15:00:00', 'INV006', 'CUST006', 124);

GO

CREATE OR ALTER TRIGGER trg_C1_CheckExpiryDate
ON IMPORT_DETAIL
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted d
        JOIN IMPORT_RECEIPT r ON d.Import_id = r.Import_id
        JOIN PRODUCT p ON d.Product_id = p.Product_id
        WHERE p.Expiry_date IS NOT NULL 
          AND CAST(r.Import_date AS DATE) > CAST(p.Expiry_date AS DATE)
    )
    BEGIN
        RAISERROR (N'Lỗi Ràng buộc 1: Sản phẩm nhập vào đã hết hạn sử dụng.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO IMPORT_RECEIPT (Import_id, Import_date, Import_total_price, Employee_id, Warehouse_id) VALUES
(8, '2026-10-2', 60000000.00, 101, 'W001')

INSERT INTO IMPORT_DETAIL (Import_id, Import_ornum, Quantity_import, Product_id) VALUES
(8, 1, 1000, 'P001')
GO


CREATE OR ALTER TRIGGER trg_C2_AutoUpdateWarehouseStock
ON IMPORT_DETAIL
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Trừ số lượng trong bảng SUPPLY (Kho tổng) khi hàng được chuyển sang Chi nhánh
    -- Logic: Tìm dòng Supply tương ứng với Warehouse và Product để trừ
    UPDATE s
    SET s.Quantity_supply = s.Quantity_supply - i.Quantity_import
    FROM SUPPLY s
    JOIN inserted i ON s.Product_id = i.Product_id
    JOIN IMPORT_RECEIPT r ON i.Import_id = r.Import_id
    WHERE s.Warehouse_id = r.Warehouse_id;
    
    -- Lưu ý: Nếu trừ xong mà âm, Constraint CK_Supply_Positive ở trên sẽ tự động báo lỗi và Rollback.
END;
GO

INSERT INTO IMPORT_DETAIL (Import_id, Import_ornum, Quantity_import, Product_id) VALUES
(7, 1, 2000, 'P001')
GO

-- Trigger 3A: CẬP NHẬT KHO CHI NHÁNH KHI NHẬP HÀNG (UPSERT)
CREATE OR ALTER TRIGGER trg_C3_AddBranchStock_OnImport
ON IMPORT_DETAIL
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- BƯỚC 1: CẬP NHẬT (UPDATE) CHO CÁC SẢN PHẨM ĐÃ CÓ
    UPDATE bp
    SET bp.Quantity_present = bp.Quantity_present + i.Quantity_import
    FROM BRANCH_PRODUCT bp
    JOIN inserted i ON bp.Product_id = i.Product_id
    JOIN IMPORT_RECEIPT r ON i.Import_id = r.Import_id
    JOIN EMPLOYEE e ON r.Employee_id = e.Employee_id
    WHERE bp.B_code = e.B_code;

    -- BƯỚC 2: THÊM MỚI (INSERT) CHO CÁC SẢN PHẨM CHƯA CÓ
    -- Logic: Tìm những dòng trong bảng 'inserted' mà kết hợp (B_code, Product_id) 
    -- chưa hề tồn tại trong bảng BRANCH_PRODUCT
    INSERT INTO BRANCH_PRODUCT (B_code, Product_id, Quantity_present)
    SELECT 
        e.B_code, 
        i.Product_id, 
        i.Quantity_import
    FROM inserted i
    JOIN IMPORT_RECEIPT r ON i.Import_id = r.Import_id
    JOIN EMPLOYEE e ON r.Employee_id = e.Employee_id
    WHERE NOT EXISTS (
        SELECT 1 
        FROM BRANCH_PRODUCT bp 
        WHERE bp.B_code = e.B_code AND bp.Product_id = i.Product_id
    );
END;

GO
--Trigger 3B: CẬP NHẬT KHO CHI NHÁNH KHI BÁN HÀNG
CREATE OR ALTER TRIGGER trg_UpdateStock_And_ValidateBranch
ON INVOICE_DETAIL
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- BƯỚC 1: KIỂM TRA ĐIỀU KIỆN (VALIDATION)
    -- Sử dụng LEFT JOIN để bắt được cả 2 trường hợp lỗi:
    -- 1. Sản phẩm không có trong danh mục kinh doanh của chi nhánh (bp.Product_id IS NULL)
    -- 2. Sản phẩm có nhưng số lượng tồn kho không đủ (bp.Quantity_present < Quantity_sales)
    
    IF EXISTS (
        SELECT 1
        FROM inserted d
        JOIN INVOICE inv ON d.Invoice_id = inv.Invoice_id
        JOIN EMPLOYEE e ON inv.Employee_id = e.Employee_id
        -- Dùng LEFT JOIN: Lấy tất cả hàng bán ra (d), soi vào kho (bp)
        LEFT JOIN BRANCH_PRODUCT bp ON bp.B_code = e.B_code AND bp.Product_id = d.Product_id
        WHERE 
            bp.Product_id IS NULL -- Lỗi 1: Sản phẩm không tồn tại ở chi nhánh này
            OR 
            (bp.Quantity_present - d.Quantity_sales < 0) -- Lỗi 2: Không đủ hàng
    )
    BEGIN
        RAISERROR (N'Error: Product does not exist in this branch OR Inventory quantity is insufficient.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- BƯỚC 2: TÍNH TOÁN VÀ CẬP NHẬT (CALCULATION)
    -- Chỉ cập nhật những dòng hợp lệ (đã qua bước kiểm tra trên)
    UPDATE bp
    SET bp.Quantity_present = bp.Quantity_present - i.Quantity_sales
    FROM BRANCH_PRODUCT bp
    JOIN inserted i ON bp.Product_id = i.Product_id
    JOIN INVOICE inv ON i.Invoice_id = inv.Invoice_id
    JOIN EMPLOYEE e ON inv.Employee_id = e.Employee_id
    WHERE bp.B_code = e.B_code;

END;
GO

--Test 3A
INSERT INTO INVOICE_DETAIL (Invoice_id, Invoice_ornum, Quantity_sales, Product_id) VALUES
('INV007', 2, 5, 'P005')

--Test 3B
INSERT INTO IMPORT_RECEIPT (Import_id, Import_date, Import_total_price, Employee_id, Warehouse_id) VALUES
(9, '2025-10-23', 0, 103, 'W003')
INSERT INTO IMPORT_DETAIL (Import_id, Import_ornum, Quantity_import, Product_id) VALUES
(9, 1, 10, 'P001')
INSERT INTO INVOICE_DETAIL (Invoice_id, Invoice_ornum, Quantity_sales, Product_id) VALUES
('INV007', 1, 5, 'P001')
INSERT INTO IMPORT_DETAIL (Import_id, Import_ornum, Quantity_import, Product_id) VALUES
(3, 2, 1, 'P001')

GO 

CREATE OR ALTER TRIGGER trg_C4_ValidateInvoice_Role
ON INVOICE -- Đặt ở đây là chuẩn nhất cho việc check nhân viên
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra ngay lúc tạo hóa đơn (INSERT) hoặc lúc đổi nhân viên (UPDATE)
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN EMPLOYEE e ON i.Employee_id = e.Employee_id
        -- Kiểm tra xem có trong bảng SALESMAN không
        LEFT JOIN SALESMAN s ON e.Employee_id = s.Employee_id
        WHERE s.Employee_id IS NULL -- Không phải Salesman
           OR e.B_code IS NULL      -- Chưa có chi nhánh
    )
    BEGIN
        RAISERROR (N'Lỗi Ràng buộc 4: Chỉ nhân viên Salesman thuộc chi nhánh mới được phép lập hóa đơn.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE OR ALTER TRIGGER trg_C4_ValidateImportReceipt
ON IMPORT_RECEIPT
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nhiệm vụ duy nhất: Kiểm tra Người nhập hàng có phải MANAGER và thuộc CHI NHÁNH không?
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN EMPLOYEE e ON i.Employee_id = e.Employee_id
        -- Left join với bảng MANAGER để kiểm tra vai trò
        LEFT JOIN MANAGER m ON i.Employee_id = m.Employee_id
        WHERE m.Employee_id IS NULL -- Lỗi: Không phải Manager
           OR e.B_code IS NULL      -- Lỗi: Manager chưa thuộc chi nhánh
    )
    BEGIN
        RAISERROR (N'Lỗi Ràng buộc 4: Chỉ Manager thuộc chi nhánh mới được phép lập phiếu nhập.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--Test 4A
INSERT INTO EMPLOYEE (Employee_id, Employee_FName, Employee_LName, Employee_birth, Employee_gender, Position, B_code) VALUES
(125, N'Bùi', N'Thị Nga', '1997-05-22', 'F', N'Salesman', NULL)
INSERT INTO SALESMAN (Employee_id) VALUES
(125)
INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) VALUES
('INV0011', '2025-11-01', 150000.00, 125, 'CUST001')

--Test 4B
INSERT INTO EMPLOYEE (Employee_id, Employee_FName, Employee_LName, Employee_birth, Employee_gender, Position, B_code) VALUES
(100, N'Phan', N'Kim Ánh', '1980-09-23', 'M', N'Manager', NULL)
INSERT INTO MANAGER (Employee_id, Degree) VALUES
(100, N'Thạc sĩ Kinh tế')
INSERT INTO IMPORT_RECEIPT (Import_id, Import_date, Import_total_price, Employee_id, Warehouse_id) VALUES
(10, '2026-10-2', 60000000.00, 100, 'W001')
GO

CREATE OR ALTER TRIGGER trg_Constraint5_UniqueCustomerInfo
ON CUSTOMER
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;


    -- Kiểm tra xem khách hàng vừa thêm (trong bảng 'inserted') 
    -- có trùng toàn bộ thông tin với ai đó đã có trong bảng 'CUSTOMER' không.
    
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN CUSTOMER c ON i.Fname = c.Fname 
                       AND i.Lname = c.Lname 
                       AND i.Customer_birth = c.Customer_birth
                       AND i.Customer_gender = c.Customer_gender
                       AND i.Customer_addr = c.Customer_addr
        -- Điều kiện quan trọng: ID phải khác nhau (để không so sánh với chính nó vừa thêm vào)
        WHERE i.Customer_id <> c.Customer_id
    )
    BEGIN
        RAISERROR (N'Lỗi Thông tin khách hàng đã tồn tại trên hệ thống: Trùng Tên, Tuổi, Giới tính, Địa chỉ.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO CUSTOMER (Customer_id, Fname, Lname, Customer_addr, Customer_birth, Customer_gender) VALUES
('CUST007', N'Nguyễn', N'Văn Nam', N'1A CMT8, TP.HCM', '1975-01-25', 'M')
GO

CREATE OR ALTER TRIGGER trg_C6_ValidateFeedback
ON FEEDBACK
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 
        FROM inserted f
        JOIN INVOICE i ON f.Invoice_id = i.Invoice_id
        WHERE f.Invoice_id IS NOT NULL 
          AND f.Customer_id <> i.Customer_id
    )
    BEGIN
        RAISERROR (N'Lỗi Ràng buộc 6: Feedback không hợp lệ: Khách hàng không phải người mua đơn này.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO FEEDBACK (Feedback_id, Feedback_content, Feedback_date, Invoice_id, Customer_id, Employee_id) VALUES
('FB007', N'Dịch vụ tốt, dược sĩ tư vấn nhiệt tình.', '2025-11-01 10:30:00', 'INV006', 'CUST001', 111)
GO

CREATE OR ALTER TRIGGER trg_Loyalty_Process
ON INVOICE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. CHỈ CHẠY KHI TỔNG TIỀN ĐƯỢC CẬP NHẬT
    IF NOT UPDATE(Invoice_total_price) RETURN;

    -- 2. KHAI BÁO BIẾN
    DECLARE @InvoiceID VARCHAR(10);
    DECLARE @OriginalTotal DECIMAL(18, 2); 
    DECLARE @FinalTotal DECIMAL(18, 2);    
    DECLARE @InvoiceDate DATE;
    DECLARE @CustID VARCHAR(10);
    
    DECLARE @CurrentRank NVARCHAR(20);
    DECLARE @CurrentPoints DECIMAL(18, 2);
    DECLARE @LastInvoiceDate DATE;
    DECLARE @DiscountRate DECIMAL(4, 2) = 0;

    -- 3. LẤY DỮ LIỆU
    SELECT TOP 1 
        @InvoiceID = i.Invoice_id,
        @OriginalTotal = i.Invoice_total_price,
        @CustID = i.Customer_id,
        @InvoiceDate = i.Invoice_date
    FROM inserted i;

    IF @CustID IS NULL RETURN;

    -- 4. LẤY THÔNG TIN KHÁCH HÀNG
    SELECT @CurrentRank = Customer_rank, @CurrentPoints = Accumulated_points
    FROM CUSTOMER WHERE Customer_id = @CustID;

    -- ============================================================
    -- BƯỚC 1: LAZY RESET (QUAN TRỌNG: RESET CẢ HẠNG & ĐIỂM)
    -- ============================================================
    SELECT @LastInvoiceDate = MAX(Invoice_date)
    FROM INVOICE WHERE Customer_id = @CustID AND Invoice_id <> @InvoiceID;

    IF @LastInvoiceDate IS NULL OR YEAR(@InvoiceDate) > YEAR(@LastInvoiceDate)
    BEGIN
        SET @CurrentPoints = 0; 
        SET @CurrentRank = N'Standard'; -- <--- SỬA: Reset hạng về Standard ngay lập tức
    END

    -- ============================================================
    -- BƯỚC 2: TÍNH KHUYẾN MÃI (Dựa trên hạng ĐÃ RESET)
    -- ============================================================
    -- Lúc này @CurrentRank đã là 'Standard', nên sẽ KHÔNG được giảm giá
    SET @FinalTotal = @OriginalTotal; 

    IF @OriginalTotal >= 100000 
    BEGIN
        IF @CurrentRank = N'Silver' SET @DiscountRate = 0.05;
        ELSE IF @CurrentRank = N'Gold' SET @DiscountRate = 0.10;
        ELSE IF @CurrentRank = N'Diamond' SET @DiscountRate = 0.15;
        -- Nếu là Standard thì DiscountRate vẫn là 0

        IF @DiscountRate > 0
        BEGIN
            SET @FinalTotal = @OriginalTotal * (1.0 - @DiscountRate);
            UPDATE INVOICE SET Invoice_total_price = @FinalTotal WHERE Invoice_id = @InvoiceID;
        END
    END

    -- ============================================================
    -- BƯỚC 3: TÍCH ĐIỂM & XẾP HẠNG MỚI
    -- ============================================================
    -- Điểm mới = 0 + Tiền đơn hàng này
    DECLARE @NewPoints DECIMAL(18, 2) = @CurrentPoints + @OriginalTotal; 
    DECLARE @NewRank NVARCHAR(20);

    -- Xét hạng dựa trên điểm vừa mua xong
    SET @NewRank = CASE 
        WHEN @NewPoints >= 10000000 THEN N'Diamond'
        WHEN @NewPoints >= 3000000 THEN N'Gold'
        WHEN @NewPoints >= 1000000 THEN N'Silver'
        ELSE N'Standard'
    END;

    -- Cập nhật
    UPDATE CUSTOMER
    SET Accumulated_points = @NewPoints, Customer_rank = @NewRank
    WHERE Customer_id = @CustID;
END;
GO

PRINT N'--- 1. CHUẨN BỊ DỮ LIỆU ---';

-- Xóa dữ liệu cũ để tránh lỗi
DELETE FROM INVOICE WHERE Customer_id = 'C_LOYALTY';
DELETE FROM CUSTOMER WHERE Customer_id = 'C_LOYALTY';
DELETE FROM SALESMAN WHERE Employee_id = 8888;
DELETE FROM EMPLOYEE WHERE Employee_id = 8888;

-- Tạo Nhân viên bán hàng
INSERT INTO EMPLOYEE (Employee_id, Employee_FName, Employee_LName, B_code) 
VALUES (8888, N'Test', N'Loyalty', 'B001'); -- Giả sử đã có chi nhánh B001
INSERT INTO SALESMAN (Employee_id) VALUES (8888);

-- Tạo Khách hàng mới (Điểm 0, Hạng Standard)
INSERT INTO CUSTOMER (Customer_id, Fname, Lname, Accumulated_points, Customer_rank) 
VALUES ('C_LOYALTY', N'Nguyen', N'Van Test', 0, N'Standard');

-- Tạo 1 hóa đơn cũ năm 2024 để làm mốc thời gian (Giá trị nhỏ để không ảnh hưởng hạng)
INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id)
VALUES ('INV_OLD', '2024-12-31', 50000, 8888, 'C_LOYALTY');

PRINT N' ';
PRINT N'=== CASE 1: MUA 900K (TÍCH ĐIỂM - CHƯA LÊN HẠNG) ===';

INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) 
VALUES ('INV_01', '2024-05-01', 0, 8888, 'C_LOYALTY');

-- Cập nhật tiền để kích hoạt Trigger
UPDATE INVOICE SET Invoice_total_price = 900000 WHERE Invoice_id = 'INV_01';

-- Kiểm tra
SELECT Customer_id, 
       Accumulated_points AS [Diem (Mong doi: 900,000)], 
       Customer_rank AS [Hang (Mong doi: Standard)]
FROM CUSTOMER WHERE Customer_id = 'C_LOYALTY';

PRINT N' ';
PRINT N'=== CASE 2: MUA THÊM 200K (LÊN HẠNG SILVER) ===';

INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) 
VALUES ('INV_02', '2024-05-02', 0, 8888, 'C_LOYALTY');

UPDATE INVOICE SET Invoice_total_price = 200000 WHERE Invoice_id = 'INV_02';

-- Kiểm tra
SELECT Customer_id, 
       Accumulated_points AS [Diem (Mong doi: 1,100,000)], 
       Customer_rank AS [Hang (Mong doi: Silver)]
FROM CUSTOMER WHERE Customer_id = 'C_LOYALTY';

PRINT N' ';
PRINT N'=== CASE 3: GIẢM GIÁ 5% & TÍCH ĐIỂM TRÊN GIÁ GỐC ===';

INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) 
VALUES ('INV_03', '2024-06-01', 0, 8888, 'C_LOYALTY');

-- Nhập giá gốc 1 triệu
UPDATE INVOICE SET Invoice_total_price = 1000000 WHERE Invoice_id = 'INV_03';

-- Kiểm tra tiền hóa đơn (Phải được giảm)
SELECT Invoice_id, Invoice_total_price AS [Tien Khach Tra (Mong doi: 950,000)] 
FROM INVOICE WHERE Invoice_id = 'INV_03';

-- Kiểm tra điểm (Phải cộng đủ 1 triệu)
SELECT Customer_id, Accumulated_points AS [Tong Diem (Mong doi: 2,100,000)]
FROM CUSTOMER WHERE Customer_id = 'C_LOYALTY';

PRINT N' ';
PRINT N'=== CASE 4: SANG NĂM MỚI 2025 (RESET ĐIỂM & HẠNG) ===';

INSERT INTO INVOICE (Invoice_id, Invoice_date, Invoice_total_price, Employee_id, Customer_id) 
VALUES ('INV_04', '2025-01-01', 0, 8888, 'C_LOYALTY');

UPDATE INVOICE SET Invoice_total_price = 500000 WHERE Invoice_id = 'INV_04';

-- Kiểm tra tiền (Không được giảm giá)
SELECT Invoice_id, Invoice_total_price AS [Tien Tra (Mong doi: 500,000)] 
FROM INVOICE WHERE Invoice_id = 'INV_04';

-- Kiểm tra điểm & Hạng (Đã bị Reset và tích mới)
SELECT Customer_id, 
       Accumulated_points AS [Diem Moi (Mong doi: 500,000)], 
       Customer_rank AS [Hang Moi (Mong doi: Standard)]
FROM CUSTOMER WHERE Customer_id = 'C_LOYALTY';
-----2.2.1---
--CREATE TRIGGER trg_ValidateFeedbackOwner
--ON FEEDBACK
--AFTER INSERT, UPDATE
--AS
--BEGIN
--    IF EXISTS (
--        SELECT 1 
--        FROM inserted i
--        JOIN INVOICE inv ON i.Invoice_id = inv.Invoice_id
--        WHERE i.Invoice_id IS NOT NULL AND i.Customer_id <> inv.Customer_id
--    )
--    BEGIN
--        RAISERROR (N'Error: Feedback is invalid. Customer is not the owner of this invoice.', 16, 1);
--        ROLLBACK TRANSACTION;
--    END
--END;

--GO
-----2.2.2---
--CREATE TRIGGER trg_UpdateStock_And_ValidateBranch
--ON INVOICE_DETAIL
--AFTER INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;
    
--    IF EXISTS (
--        SELECT 1
--        FROM inserted d
--        JOIN INVOICE inv ON d.Invoice_id = inv.Invoice_id
--        JOIN EMPLOYEE e ON inv.Employee_id = e.Employee_id
--        JOIN BRANCH_PRODUCT bp ON bp.B_code = e.B_code AND bp.Product_id = d.Product_id
--        WHERE bp.Quantity_present - d.Quantity_sales < 0 
--    )
--    BEGIN
--        RAISERROR (N'Error: The inventory quantity at the branch is not enough to perform the transaction or the product does not belong to this branch.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

--    UPDATE bp
--    SET bp.Quantity_present = bp.Quantity_present - i.Quantity_sales
--    FROM BRANCH_PRODUCT bp
--    JOIN inserted i ON bp.Product_id = i.Product_id
--    JOIN INVOICE inv ON i.Invoice_id = inv.Invoice_id
--    JOIN EMPLOYEE e ON inv.Employee_id = e.Employee_id
--    WHERE bp.B_code = e.B_code;

--END;

--GO
-----2.4---
--CREATE FUNCTION fn_TinhTongTienNhapKho
--(
--    @Warehouse_id VARCHAR(10),
--    @Year INT
--)
--RETURNS DECIMAL(18, 2)
--AS
--BEGIN
    
--    DECLARE @TotalImport DECIMAL(18, 2) = 0;
--    DECLARE @CurrentBill DECIMAL(18, 2);

--    IF NOT EXISTS (SELECT 1 FROM WAREHOUSE WHERE Warehouse_id = @Warehouse_id)
--    BEGIN
--        RETURN -1; 
--    END

--    IF @Year < 2000
--    BEGIN
--        RETURN -2; 
--    END

--    DECLARE cursor_Import CURSOR FOR
--    SELECT Import_total_price
--    FROM IMPORT_RECEIPT
--    WHERE Warehouse_id = @Warehouse_id 
--      AND YEAR(Import_date) = @Year;

--    OPEN cursor_Import;
--    FETCH NEXT FROM cursor_Import INTO @CurrentBill;

--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        IF @CurrentBill IS NOT NULL AND @CurrentBill > 0
--        BEGIN
--            SET @TotalImport = @TotalImport + @CurrentBill;
--        END

--        FETCH NEXT FROM cursor_Import INTO @CurrentBill;
--    END

--    CLOSE cursor_Import;
--    DEALLOCATE cursor_Import;

--    RETURN @TotalImport;
--END;
--GO

--CREATE FUNCTION fn_TinhTongDoanhThuChiNhanh
--(
--    @B_code VARCHAR(10), 
--    @Month INT,
--    @Year INT
--)
--RETURNS DECIMAL(18, 2)
--AS
--BEGIN
--    DECLARE @TotalRevenue DECIMAL(18, 2) = 0;
--    DECLARE @CurrentBill DECIMAL(18, 2);

--    IF NOT EXISTS (SELECT 1 FROM BRANCH WHERE B_code = @B_code)
--    BEGIN
--        RETURN -1; 
--    END

--    IF @Month < 1 OR @Month > 12
--    BEGIN
--        RETURN -2;
--    END

--    DECLARE cursor_BranchRevenue CURSOR FOR
--    SELECT I.Invoice_total_price
--    FROM INVOICE I
--    JOIN SALESMAN S ON I.Employee_id = S.Employee_id       
--    JOIN EMPLOYEE E ON S.Employee_id = E.Employee_id       
--    WHERE E.B_code = @B_code                               
--      AND MONTH(I.Invoice_date) = @Month
--      AND YEAR(I.Invoice_date) = @Year;

--    OPEN cursor_BranchRevenue;
--    FETCH NEXT FROM cursor_BranchRevenue INTO @CurrentBill;

--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        IF @CurrentBill > 0
--        BEGIN
--            SET @TotalRevenue = @TotalRevenue + @CurrentBill;
--        END

--        FETCH NEXT FROM cursor_BranchRevenue INTO @CurrentBill;
--    END

--    CLOSE cursor_BranchRevenue;
--    DEALLOCATE cursor_BranchRevenue;

--    RETURN @TotalRevenue;
--END;
--GO

-----2.2.1 TEST---
--PRINT N'--- TEST 2.2.1';
--BEGIN TRY
--    INSERT INTO FEEDBACK (Feedback_id, Feedback_content, Feedback_date, Invoice_id, Customer_id, Employee_id) 
--    VALUES ('FB_FAIL', N'Bad Service', GETDATE(), 'INV007', 'CUST002', 121);
--    PRINT N'Fail: Trigger can not be catched.';
--END TRY
--BEGIN CATCH
--    PRINT N'Success: Trigger catched err -> ' + ERROR_MESSAGE();
--END CATCH;

-----2.2.2---
--PRINT N' ';
--PRINT N'=== TEST 2: KIỂM TRA CẬP NHẬT KHO ===';

---- Khai báo biến để hứng dữ liệu tồn kho
--DECLARE @CurrentStock INT;

---- Tình huống 1: Bán quá số lượng tồn
---- Kho B003 có P018 = 2. Bán 5 -> Lỗi.
--BEGIN TRY
--    INSERT INTO INVOICE_DETAIL (Invoice_id, Invoice_ornum, Quantity_sales, Product_id)
--    VALUES ('INV007', 1, 5, 'P018');
--    PRINT N'Thất bại: Cho phép bán quá số lượng tồn.';
--END TRY
--BEGIN CATCH
--    PRINT N'Thành công: Đã chặn bán quá số lượng -> ' + ERROR_MESSAGE();
--END CATCH;

---- Tình huống 2: Bán hợp lệ & Trừ kho
---- Kho B003 có P002 = 100. Bán 5 -> Còn 95.

---- Bước 1: Lấy tồn kho TRƯỚC khi bán ra biến
--SELECT @CurrentStock = Quantity_present 
--FROM BRANCH_PRODUCT 
--WHERE B_code='B003' AND Product_id='P002';

--PRINT N'-> Trước khi bán P002 (B003): ' + CAST(@CurrentStock AS VARCHAR(20));

---- Bước 2: Thực hiện bán
--INSERT INTO INVOICE_DETAIL (Invoice_id, Invoice_ornum, Quantity_sales, Product_id)
--VALUES ('INV007', 2, 5, 'P002');

---- Bước 3: Lấy tồn kho SAU khi bán ra biến
--SELECT @CurrentStock = Quantity_present 
--FROM BRANCH_PRODUCT 
--WHERE B_code='B003' AND Product_id='P002';

--PRINT N'-> Sau khi bán 5 cái: ' + CAST(@CurrentStock AS VARCHAR(20));
-----2.4.1---
--PRINT N' ';
--PRINT N'--- TEST 3: HÀM TÍNH TỔNG TIỀN NHẬP KHO (W001 - 2025) ---';

--DECLARE @TongTienNhap DECIMAL(18,2);
--SET @TongTienNhap = dbo.fn_TinhTongTienNhapKho('W001', 2025);

---- Dữ liệu: Phiếu 1 (60tr) + Phiếu 7 mới thêm (40tr) = 100tr
--SELECT 
--    'W001' AS [Kho], 2025 AS [Năm], 
--    FORMAT(@TongTienNhap, 'N2') AS [Tổng Tiền (Mong đợi: 100,000,000)],
--    CASE WHEN @TongTienNhap = 100000000 THEN 'PASSED' ELSE 'FAILED' END AS [Kết Quả];

-----2.4.2---
--PRINT N' ';
--PRINT N'--- TEST 4: HÀM TÍNH DOANH THU CHI NHÁNH (B003 - 11/2025) ---';

--DECLARE @DoanhThuCN DECIMAL(18,2);
---- Tính cho Chi nhánh B003 (Nơi Salesman 109 làm việc)
--SET @DoanhThuCN = dbo.fn_TinhTongDoanhThuChiNhanh('B003', 11, 2025);

---- Dữ liệu: INV003 (90k - dữ liệu cũ) + INV007 (350k - dữ liệu mới) = 440k
---- Lưu ý: INV001 là 150k nhưng năm 2025 (trong dữ liệu mẫu bạn cung cấp INV001 ngày 2025-11-01).
---- Kiểm tra lại dữ liệu mẫu của bạn:
---- INV001: 150,000 (NV 109 - B003)
---- INV003: 90,000 (NV 117 - B005) -> CHÚ Ý: NV 117 làm ở B005 chứ không phải B003.
---- INV007: 350,000 (NV 109 - B003)
---- => Tổng B003 = INV001 (150k) + INV007 (350k) = 500,000.

--SELECT 
--    'B003' AS [Chi Nhánh], '11/2025' AS [Thời Gian],
--    FORMAT(@DoanhThuCN, 'N2') AS [Doanh Thu (Mong đợi: 620,000)],
--    CASE WHEN @DoanhThuCN = 500000 THEN 'PASSED' ELSE 'FAILED' END AS [Kết Quả];