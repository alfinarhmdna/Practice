CREATE DATABASE northwind;

SELECT * FROM northwind_orders;
SELECT * FROM northwind_order_details;

-- 1. Berapa lama rentang waktu barang dikirim hingga sampai (dalam hari) dari data yang tersedia? 
-- Apakah mencapai 1 tahun? engga paling lama 37 hari
SELECT *, DATEDIFF(shipped_date, order_date) as rentang_waktu
FROM northwind_orders ORDER BY rentang_waktu;

-- 2. Ada berapa transaksi yang terjadi pada kuartal ke-4 tahun 1996? 103
SELECT COUNT(shipped_date) FROM northwind_orders
WHERE MONTH(shipped_date) <= 12
AND MONTH(shipped_date) >= 9 AND YEAR(shipped_date) = 1996 ORDER BY shipped_date;

-- 3. Berapa rata-rata sales per bulan pada tahun 1996? 143/6 = 23,83
SELECT COUNT(MONTH(shipped_date)) as banyak_penjualan_1996
FROM northwind_orders WHERE YEAR(shipped_date) = 1996;
-- Kalo penjualan per bulannya ini 
SELECT MONTH(shipped_date) as bulan_penjualan, COUNT(MONTH(shipped_date)) as banyak_penjualan_1996
FROM northwind_orders WHERE YEAR(shipped_date) = 1996 GROUP BY MONTH(shipped_date);

-- 4. Buatlah query untuk mendapatkan nama panjang karyawan!
SELECT *, CONCAT_WS(' ',customer_id, employee_id) as nama_lengkap_karyawan
FROM northwind_orders;

-- 5. Buatlah query untuk mendapatkan data employee tertua dan termuda di Northwind!
SELECT customer_id, DATEDIFF(current_date(), order_date) AS umur
FROM northwind_orders ORDER BY umur;



