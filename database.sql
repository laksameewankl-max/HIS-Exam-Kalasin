-- ========================================================
-- HIS University Hospital - Exam Project (Kalasin)
-- Part 1: Database Schema & Query
-- ========================================================

-- --------------------------------------------------------
-- 1. Schema Definition (สร้างตารางตามโจทย์)
-- --------------------------------------------------------

-- ตารางข้อมูลผู้ป่วย (Patient_Data)
CREATE TABLE Patient_Data (
    HN VARCHAR(10) PRIMARY KEY, -- Hospital Number (Key หลัก)
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL, -- วันเกิด
    District VARCHAR(50) -- อำเภอ
);

-- ตารางประวัติการเข้ารับบริการ (Visit_Log)
CREATE TABLE Visit_Log (
    VN VARCHAR(10) PRIMARY KEY, -- Visit Number (Key หลักของการมาแต่ละครั้ง)
    HN VARCHAR(10), -- เชื่อมไปที่ผู้ป่วย
    VisitDate DATE NOT NULL, -- วันที่มาตรวจ
    Clinic_Name VARCHAR(50) NOT NULL, -- ชื่อคลินิก (เช่น 'คลินิกอายุรกรรม')
    FOREIGN KEY (HN) REFERENCES Patient_Data(HN)
);

-- ตารางข้อมูลการวินิจฉัย (Diagnosis_Record)
CREATE TABLE Diagnosis_Record (
    VN VARCHAR(10), -- เชื่อมไปที่การมาตรวจ
    ICD10_Code VARCHAR(10), -- รหัสวินิจฉัยโรค
    Attending_Doctor VARCHAR(100), -- อาจารย์แพทย์ผู้ดูแล
    Med_Student VARCHAR(100), -- นักศึกษาแพทย์ผู้ตรวจ
    PRIMARY KEY (VN, ICD10_Code), -- Key คู่ป้องกันข้อมูลซ้ำในการมาครั้งเดียว
    FOREIGN KEY (VN) REFERENCES Visit_Log(VN)
);

-- --------------------------------------------------------
-- 2. Insert Mock Data (ใส่ข้อมูลจำลองเพื่อให้ Query ทำงานได้)
-- --------------------------------------------------------

-- ข้อมูลผู้ป่วย
INSERT INTO Patient_Data VALUES ('HN67001', 'สมชาย', 'ใจดี', '1980-05-20', 'เมือง');
INSERT INTO Patient_Data VALUES ('HN67002', 'สมหญิง', 'รักเรียน', '1995-11-12', 'ยางตลาด');
INSERT INTO Patient_Data VALUES ('HN67003', 'นายกมล', 'คนขยัน', '1975-03-10', 'กมลาไสย');

-- ข้อมูลการมาตรวจ (สมมติปีปัจจุบันคือ 2026 ตามเงื่อนไขโจทย์ ม.ค. - มี.ค.)
INSERT INTO Visit_Log VALUES ('VN26001', 'HN67001', '2026-02-15', 'คลินิกอายุรกรรม'); -- ตรงเงื่อนไข
INSERT INTO Visit_Log VALUES ('VN26002', 'HN67002', '2026-02-20', 'คลินิกศัลยกรรม'); -- ผิดคลินิก
INSERT INTO Visit_Log VALUES ('VN26003', 'HN67003', '2026-03-10', 'คลินิกอายุรกรรม'); -- ตรงเงื่อนไข
INSERT INTO Visit_Log VALUES ('VN26004', 'HN67001', '2026-04-05', 'คลินิกอายุรกรรม'); -- ผิดช่วงเวลา

-- ข้อมูลการวินิจฉัย
INSERT INTO Diagnosis_Record VALUES ('VN26001', 'E11.9', 'นพ.วิชาญ (อาจารย์)', 'นศพ.เก่งกาจ'); -- ตรงเงื่อนไข (เบาหวาน)
INSERT INTO Diagnosis_Record VALUES ('VN26002', 'K29.7', 'นพ.สมเกียรติ (อาจารย์)', 'นศพ.ขยัน'); -- ผิดโรค
INSERT INTO Diagnosis_Record VALUES ('VN26003', 'E11.65', 'นพ.วิชาญ (อาจารย์)', 'นศพ.จริงใจ'); -- ตรงเงื่อนไข (เบาหวาน)
INSERT INTO Diagnosis_Record VALUES ('VN26004', 'E11.9', 'นพ.อนันต์ (อาจารย์)', 'นศพ.เก่งกาจ'); -- ตรงโรคแต่ผิดเวลา

-- --------------------------------------------------------
-- 3. SQL Query สำหรับงานวิจัย (คำตอบข้อ 1)
-- --------------------------------------------------------
-- เงื่อนไข: 
-- 1. ICD-10 ขึ้นต้นด้วย E11 (เบาหวาน)
-- 2. คลินิก 'คลินิกอายุรกรรม'
-- 3. วันที่ 1 ม.ค. - 31 มี.ค. 2026
-- 4. เรียงลำดับวันที่ล่าสุดไปเก่าที่สุด

SELECT 
    p.FirstName, 
    p.LastName, 
    v.VisitDate, 
    d.ICD10_Code, 
    d.Attending_Doctor
FROM Patient_Data p
JOIN Visit_Log v ON p.HN = v.HN
JOIN Diagnosis_Record d ON v.VN = d.VN
WHERE d.ICD10_Code LIKE 'E11%' 
  AND v.Clinic_Name = 'คลินิกอายุรกรรม'
  AND v.VisitDate BETWEEN '2026-01-01' AND '2026-03-31'
ORDER BY v.VisitDate DESC;
