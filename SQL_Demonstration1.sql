-- 1) Crear la base de datos 'Demonstration1' verificando que la misma no exista en el motor de base de datos. 
-- 1) Create the database 'Demonstration1' checking that it does not exist in the database engine.
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name ='Demonstration1')
    CREATE DATABASE Demonstration1;
USE Demonstration1;

-- Eliminar las tablas si existen
-- Drop the tables if they exist
DROP TABLE IF EXISTS medics;        -- medicos
DROP TABLE IF EXISTS patients;      -- pacientes
DROP TABLE IF EXISTS admissions;    -- ingresos
DROP TABLE IF EXISTS zones;         -- zonas
DROP TABLE IF EXISTS beds;          -- camas
DROP TABLE IF EXISTS specialties;   -- especialidad


-- 2) Crear las tablas que se muestran en la imagen, de acuerdo con las restricciones que se mencionan en cada caso. 
-- 2) Create the tables shown in the image according to the constraints mentioned in each case.
CREATE TABLE medics (               -- medicos
    id INT NOT NULL,                -- legajo
    dni INT NOT NULL,               -- DNI
    first_name VARCHAR(10) NOT NULL, -- nombre
    last_name VARCHAR(20) NOT NULL,  -- apellido
    specialty VARCHAR(20) NOT NULL,   -- especialidad
    resident BIT NOT NULL,            -- residente
    salary INT NOT NULL,              -- sueldo
    
    CONSTRAINT PK_medics PRIMARY KEY (id),
    CONSTRAINT UQ_medics UNIQUE (dni),
    CONSTRAINT CK_SALARY CHECK (salary >= 35000 AND salary <= 250000)
);

CREATE TABLE patients (             -- pacientes
    id INT NOT NULL,                -- legajo
    dni INT NOT NULL,               -- DNI
    first_name VARCHAR(10) NOT NULL, -- nombre
    last_name VARCHAR(20) NOT NULL,  -- apellido
    address VARCHAR(20) NOT NULL,     -- direccion
    birth_date DATE NOT NULL,         -- Fecha_Nac
    registration_date DATE NOT NULL,  -- Fecha_Registro
    postal_code VARCHAR(4) NOT NULL,  -- CodPostal

    CONSTRAINT PK_patients PRIMARY KEY (dni)
);

ALTER TABLE patients                 -- pacientes
ALTER COLUMN postal_code VARCHAR(40) NULL; -- CodPostal

CREATE TABLE admissions (            -- ingresos
    dni INT NOT NULL,               -- DNI
    id INT NOT NULL,                -- legajo
    attention_date DATE NOT NULL,   -- Fecha_Atencion
    room_number SMALLINT NOT NULL,  -- nro_habitacion

    CONSTRAINT PK_admissions PRIMARY KEY (dni),
    CONSTRAINT FK_admissions_dni FOREIGN KEY (dni) REFERENCES patients(dni),
    CONSTRAINT FK_id FOREIGN KEY (id) REFERENCES medics(id)
);


-- 3) Crear la tabla Camas donde la clave primaria está compuesta por la zona del hospital y el número de la cama.
-- 3) Create the beds table where the primary key is composed of the hospital zone and the bed number.
CREATE TABLE zones (                 -- zonas
    id INT NOT NULL,                -- CodZona
    name VARCHAR(20) NOT NULL,      -- NomZona

    CONSTRAINT PK_zones PRIMARY KEY (id),
    CONSTRAINT CK_Name CHECK (id IN (1, 2, 3, 4)) -- Changed to numbers for the zones
);

CREATE TABLE beds (                 -- camas
    bed_number INT NOT NULL,        -- CodCama
    zone_id INT NOT NULL,           -- CodZona

    CONSTRAINT PK_beds PRIMARY KEY (bed_number, zone_id),
    CONSTRAINT CK_BedNumbers CHECK (bed_number >= 1 AND bed_number <= 50),
    CONSTRAINT FK_BedsZones FOREIGN KEY (zone_id) REFERENCES zones(id)
);


-- 4) Escribe la sentencia SQL para poder registrar el número de cama en la que estuvo cada paciente cuando fue internado.
-- 4) Write the SQL statement to register the bed number where each patient was when they were admitted.
ALTER TABLE admissions                    -- ingresos
ADD bed_number INT NULL;                 -- CodCama

ALTER TABLE admissions                    -- ingresos
ADD zone_id INT NULL;                    -- CodZona

ALTER TABLE admissions                    -- ingresos
ADD CONSTRAINT FK_admissions_bed FOREIGN KEY (bed_number, zone_id) REFERENCES beds(bed_number, zone_id);


-- 5) Modifica la relación Ingreso, considerando que la clave primaria está compuesta por DNI, legajo y fecha_atencion.
-- 5) Modify the Admission relationship, considering that the primary key is composed of dni, id, and attention_date.
ALTER TABLE admissions                    -- ingresos
DROP CONSTRAINT PK_admissions;           -- PK_ingresos

ALTER TABLE admissions                    -- ingresos
ADD CONSTRAINT PK_admissions PRIMARY KEY (dni, id, attention_date); -- DNI, legajo, Fecha_Atencion


-- 6) Realiza las modificaciones que creas apropiadas para crear una tabla Especialidad y relacionarla con Médicos.
-- 6) Make the necessary modifications to create a Specialties table and relate it to Medics.
CREATE TABLE specialties (                -- especialidad
    id TINYINT NOT NULL,                 -- CodEspecialidad
    name VARCHAR(30) NOT NULL,           -- Nombre

    CONSTRAINT PK_specialties PRIMARY KEY (id)
);

ALTER TABLE medics                       -- medicos
ADD specialty_id TINYINT NOT NULL;      -- CodEspecialidad

ALTER TABLE medics                       -- medicos 
ADD CONSTRAINT FK_specialty FOREIGN KEY (specialty_id) REFERENCES specialties(id)
ON DELETE CASCADE ON UPDATE CASCADE;


-- 7) Si quisiéramos eliminar la tabla Especialidad, escribe la/s sentencia/s correspondiente/s para poder realizar esta acción.
-- 7) If we wanted to delete the Specialties table, write the corresponding statement(s) to perform this action.
IF EXISTS (SELECT * FROM sys.objects WHERE name ='specialties')
    ALTER TABLE medics                       -- medicos
    DROP CONSTRAINT FK_specialty;          -- FK_especialidad

    ALTER TABLE medics                       -- medicos
    DROP COLUMN specialty_id;               -- CodEspecialidad

    DROP TABLE specialties;                  -- especialidad