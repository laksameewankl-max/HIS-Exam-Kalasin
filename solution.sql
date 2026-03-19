-- ข้อ 1: SQL Query สำหรับคัดกรองข้อมูลผู้ป่วยเบาหวาน คลินิกอายุรกรรม (ม.ค. - มี.ค. 2569)
-- เกณฑ์: ใช้ JOIN, WHERE LIKE, ช่วงวันที่ และ ORDER BY

SELECT 
    p.FirstName AS 'ชื่อ', 
    p.LastName AS 'นามสกุล', 
    v.VisitDate AS 'วันที่รับบริการ', 
    d.ICD10_Code AS 'รหัสวินิจฉัย', 
    d.Attending_Doctor AS 'อาจารย์แพทย์ผู้ดูแล'
FROM Patient_Data p
JOIN Visit_Log v ON p.HN = v.HN
JOIN Diagnosis_Record d ON v.VN = d.VN
WHERE d.ICD10_Code LIKE 'E11%'                      -- ดึงรหัสเบาหวานที่ขึ้นต้นด้วย E11
  AND v.Clinic_Name = 'คลินิกอายุรกรรม'               -- ระบุเฉพาะคลินิกอายุรกรรม
  AND v.VisitDate BETWEEN '2026-01-01' AND '2026-03-31' -- ช่วงวันที่ตามโจทย์ (ปีปัจจุบัน 2026)
ORDER BY v.VisitDate DESC;                          -- เรียงลำดับจากล่าสุดไปเก่าที่สุด
