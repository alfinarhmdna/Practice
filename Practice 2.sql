SELECT * FROM students_performance_table;

-- 1. Bagaimana query untuk membuat stored
-- procedure yang menampilkan seluruh data pada tabel
-- ds.studenstsperformance?
DELIMITER $$
CREATE PROCEDURE GetStudentsData ()
BEGIN 
	SELECT * FROM student_performance.students_performance_table;
END $$
DELIMITER ;

CALL GetStudentsData ();

-- 2. Dengan menggunakan query pada jawaban nomor 1,
-- modifikasilah query agar dapat menampilkan data pada
-- tabel ds.studenstsperformance untuk grup ras tertentu saja!
DELIMITER $$
CREATE PROCEDURE GetDataRas
(
	IN nama_ras VARCHAR (100)
)
BEGIN
    SELECT * FROM students_performance_table where race_or_ethnicity = nama_ras;
END $$
DELIMITER ;

-- Memasukkan parameter
CALL getDataRas("group A");

-- 3.a. Buatlah stored procedure untuk memberikan nilai math rata-rata seluruh data!
DELIMITER $$
CREATE PROCEDURE GetRerataMath
(
	OUT rerata_math FLOAT
)
BEGIN
	SELECT AVG(math_score) INTO rerata_math FROM students_performance_table;
END $$
DELIMITER ;

CALL GetRerataMath(@rerata_math);
SELECT @rerata_math;

-- 3.b. Dapatkah Anda menampilkan seluruh data yang
-- memiliki nilai math lebih dari rata-rata menggunakan output
-- jawaban 3.a.? Buatlah query tersebut!
SELECT *, @rerata_math from students_performance_table 
WHERE math_score > @rerata_math ORDER BY math_score;

-- 4. Buatlah query yang menghasilkan rata-rata nilai
-- matematika berdasarkan input gender male seperti pada ilustrasi!
DELIMITER $$
CREATE PROCEDURE get_gend_math_score_avg
(
	INOUT jenis_gender VARCHAR(100),
    OUT rerata_nilai_math FLOAT
)
BEGIN
	SELECT gender, AVG(math_score) INTO jenis_gender, rerata_nilai_math 
    FROM students_performance_table WHERE gender = jenis_gender;
END $$
DELIMITER ;

SET @jenis_gender = 'male';
CALL get_gend_math_score_avg(@jenis_gender, @rerata_nilai_math);
SELECT @jenis_gender, @rerata_nilai_math;

-- 5. Lengkapi stored procedure
DROP TABLE IF EXISTS id_buku;
DROP PROCEDURE IF EXISTS buatidbuku;

CREATE TABLE id_buku (id INT);

DELIMITER $$
CREATE PROCEDURE buatidbuku()
BEGIN
	DECLARE Counter Int ;
	SET
		Counter = 0;
	WHILE Counter <= 5 DO
		INSERT INTO
			id_buku (id)
		VALUES
			(Counter);
		SET
			Counter = Counter + 1;
	END WHILE;
END $$
DELIMITER ;

CALL buatidbuku();
SELECT * FROM id_buku;

-- 6. Kita akan membuat stored procedure untuk menghitung luas segitiga dan persegi panjang.
-- Stored procedure ini akan memiliki 4 parameter, yaitu:
-- a. jenis bangun datar (IN) (string), yaitu jenis bangun datar yang akan dihitung;
-- saat ini kita hanya akan menghitung segitiga dan persegi panjang saja
-- b. x (IN) (float), yaitu jika jenis bangun datar segitiga, x adalah alas dan jika
-- persegi panjang, x adalah panjang
-- c. y (IN) (float), yaitu jika jenis bangun datar segitiga, y adalah tinggi dan jika
-- persegi panjang, y adalah lebar
-- d. luas (OUT) (float), yaitu luas bangun datar yang dihitung
-- e. keterangan (OUT) (string), yaitu keterangan apakah perhitungan berhasil dilakukan

-- Skenario 1
-- membuat stored procedure untuk menghitung luas
DROP PROCEDURE hitung_luas;

DELIMITER $$
CREATE PROCEDURE hitung_luas
(
	IN jenis_bangun_datar VARCHAR(100),
    IN x FLOAT,
    IN y FLOAT,
    OUT luas FLOAT,
    OUT keterangan VARCHAR(100)
)
BEGIN
	IF jenis_bangun_datar = 'segitiga' THEN SET luas = (1/2)*x*y, keterangan = "Perhitungan berhasil";
    ELSEIF jenis_bangun_datar = 'persegi panjang' THEN SET luas = x*y, keterangan = "Perhitungan berhasil";
    ELSE SET luas = null, keterangan = "Perhitungan gagal. Bangun datar tidak didukung";
    END IF;
END $$
DELIMITER ;

SET @jenis_bangun_datar = 'lingkaran';
SET @x = 10;
SET @y = 20;
CALL hitung_luas(@jenis_bangun_datar, @x, @y, @luas, @keterangan);
SELECT @jenis_bangun_datar, @x, @y, @luas, @keterangan;
