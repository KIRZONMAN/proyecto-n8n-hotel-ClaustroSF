DROP VIEW IF EXISTS vw_disponibilidad_habitaciones;
DROP TABLE IF EXISTS habitaciones_demo;

CREATE TABLE habitaciones_demo (
    id SERIAL PRIMARY KEY,
    codigo_habitacion VARCHAR(20) UNIQUE NOT NULL,
    tipo_habitacion VARCHAR(30) NOT NULL,
    capacidad_adultos INT NOT NULL,
    capacidad_ninos INT NOT NULL,
    capacidad_total INT NOT NULL,
    vista VARCHAR(80) NOT NULL,
    precio_noche_cop NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    descripcion TEXT,
    updated_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT chk_tipo_habitacion CHECK (
        tipo_habitacion IN ('sencilla', 'doble', 'triple', 'familiar', 'suite')
    ),

    CONSTRAINT chk_estado_habitacion CHECK (
        estado IN ('disponible', 'ocupada', 'reservada', 'mantenimiento')
    )
);

-- 120 habitaciones sencillas
INSERT INTO habitaciones_demo (
    codigo_habitacion,
    tipo_habitacion,
    capacidad_adultos,
    capacidad_ninos,
    capacidad_total,
    vista,
    precio_noche_cop,
    estado,
    descripcion
)
SELECT
    'S-' || LPAD(gs::TEXT, 3, '0') AS codigo_habitacion,
    'sencilla' AS tipo_habitacion,
    1 AS capacidad_adultos,
    1 AS capacidad_ninos,
    2 AS capacidad_total,
    CASE
        WHEN gs % 3 = 0 THEN 'vista al patio colonial'
        WHEN gs % 3 = 1 THEN 'vista interior'
        ELSE 'vista al hotel'
    END AS vista,
    120000 + ((gs % 5) * 10000) AS precio_noche_cop,
    CASE
        WHEN gs % 20 = 0 THEN 'mantenimiento'
        WHEN gs % 4 = 0 THEN 'ocupada'
        WHEN gs % 9 = 0 THEN 'reservada'
        ELSE 'disponible'
    END AS estado,
    'Habitación sencilla para huéspedes individuales, viajeros de paso o parejas que buscan una estancia básica.' AS descripcion
FROM generate_series(1, 120) AS gs;

-- 210 habitaciones dobles
INSERT INTO habitaciones_demo (
    codigo_habitacion,
    tipo_habitacion,
    capacidad_adultos,
    capacidad_ninos,
    capacidad_total,
    vista,
    precio_noche_cop,
    estado,
    descripcion
)
SELECT
    'D-' || LPAD(gs::TEXT, 3, '0') AS codigo_habitacion,
    'doble' AS tipo_habitacion,
    2 AS capacidad_adultos,
    1 AS capacidad_ninos,
    3 AS capacidad_total,
    CASE
        WHEN gs % 3 = 0 THEN 'vista al patio colonial'
        WHEN gs % 3 = 1 THEN 'vista al hotel'
        ELSE 'vista interior tranquila'
    END AS vista,
    180000 + ((gs % 6) * 15000) AS precio_noche_cop,
    CASE
        WHEN gs % 20 = 0 THEN 'mantenimiento'
        WHEN gs % 4 = 0 THEN 'ocupada'
        WHEN gs % 9 = 0 THEN 'reservada'
        ELSE 'disponible'
    END AS estado,
    'Habitación doble recomendada para parejas, viajeros de negocios o grupos pequeños.' AS descripcion
FROM generate_series(1, 210) AS gs;

-- 90 habitaciones triples
INSERT INTO habitaciones_demo (
    codigo_habitacion,
    tipo_habitacion,
    capacidad_adultos,
    capacidad_ninos,
    capacidad_total,
    vista,
    precio_noche_cop,
    estado,
    descripcion
)
SELECT
    'T-' || LPAD(gs::TEXT, 3, '0') AS codigo_habitacion,
    'triple' AS tipo_habitacion,
    3 AS capacidad_adultos,
    1 AS capacidad_ninos,
    4 AS capacidad_total,
    CASE
        WHEN gs % 2 = 0 THEN 'vista al patio colonial'
        ELSE 'vista interior amplia'
    END AS vista,
    240000 + ((gs % 5) * 20000) AS precio_noche_cop,
    CASE
        WHEN gs % 20 = 0 THEN 'mantenimiento'
        WHEN gs % 4 = 0 THEN 'ocupada'
        WHEN gs % 9 = 0 THEN 'reservada'
        ELSE 'disponible'
    END AS estado,
    'Habitación triple para grupos medianos, familias pequeñas o huéspedes que requieren mayor capacidad.' AS descripcion
FROM generate_series(1, 90) AS gs;

-- 80 habitaciones familiares
INSERT INTO habitaciones_demo (
    codigo_habitacion,
    tipo_habitacion,
    capacidad_adultos,
    capacidad_ninos,
    capacidad_total,
    vista,
    precio_noche_cop,
    estado,
    descripcion
)
SELECT
    'F-' || LPAD(gs::TEXT, 3, '0') AS codigo_habitacion,
    'familiar' AS tipo_habitacion,
    3 AS capacidad_adultos,
    2 AS capacidad_ninos,
    5 AS capacidad_total,
    CASE
        WHEN gs % 2 = 0 THEN 'vista amplia al hotel'
        ELSE 'vista al patio colonial'
    END AS vista,
    320000 + ((gs % 5) * 25000) AS precio_noche_cop,
    CASE
        WHEN gs % 20 = 0 THEN 'mantenimiento'
        WHEN gs % 4 = 0 THEN 'ocupada'
        WHEN gs % 9 = 0 THEN 'reservada'
        ELSE 'disponible'
    END AS estado,
    'Habitación familiar para grupos con niños, familias numerosas o estadías compartidas.' AS descripcion
FROM generate_series(1, 80) AS gs;

-- 50 suites
INSERT INTO habitaciones_demo (
    codigo_habitacion,
    tipo_habitacion,
    capacidad_adultos,
    capacidad_ninos,
    capacidad_total,
    vista,
    precio_noche_cop,
    estado,
    descripcion
)
SELECT
    'SU-' || LPAD(gs::TEXT, 3, '0') AS codigo_habitacion,
    'suite' AS tipo_habitacion,
    2 AS capacidad_adultos,
    2 AS capacidad_ninos,
    4 AS capacidad_total,
    CASE
        WHEN gs % 2 = 0 THEN 'vista premium al patio colonial'
        ELSE 'vista premium al hotel'
    END AS vista,
    450000 + ((gs % 5) * 50000) AS precio_noche_cop,
    CASE
        WHEN gs % 20 = 0 THEN 'mantenimiento'
        WHEN gs % 4 = 0 THEN 'ocupada'
        WHEN gs % 9 = 0 THEN 'reservada'
        ELSE 'disponible'
    END AS estado,
    'Suite con mayor comodidad para huéspedes que buscan una experiencia superior.' AS descripcion
FROM generate_series(1, 50) AS gs;

CREATE VIEW vw_disponibilidad_habitaciones AS
SELECT
    tipo_habitacion,
    COUNT(*) AS total_habitaciones,
    COUNT(*) FILTER (WHERE estado = 'disponible') AS disponibles,
    COUNT(*) FILTER (WHERE estado = 'ocupada') AS ocupadas,
    COUNT(*) FILTER (WHERE estado = 'reservada') AS reservadas,
    COUNT(*) FILTER (WHERE estado = 'mantenimiento') AS mantenimiento,
    MAX(capacidad_total) AS capacidad_maxima,
    MIN(precio_noche_cop) AS precio_minimo_cop,
    MAX(precio_noche_cop) AS precio_maximo_cop
FROM habitaciones_demo
GROUP BY tipo_habitacion;