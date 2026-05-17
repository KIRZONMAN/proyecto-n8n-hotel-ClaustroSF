CREATE TABLE IF NOT EXISTS reservas_demo (
    id SERIAL PRIMARY KEY,
    codigo_reserva TEXT NOT NULL UNIQUE,
    codigo_habitacion TEXT NOT NULL,
    tipo_habitacion TEXT NOT NULL,
    numero_personas INTEGER NOT NULL,
    numero_noches INTEGER NOT NULL,
    fecha_entrada_texto TEXT,
    precio_noche_cop NUMERIC(12, 2),
    total_estimado_cop NUMERIC(12, 2),
    pregunta_usuario TEXT,
    session_id TEXT,
    estado_reserva TEXT NOT NULL DEFAULT 'confirmada_demo',
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reservas_demo_codigo_habitacion
ON reservas_demo (codigo_habitacion);

CREATE INDEX IF NOT EXISTS idx_reservas_demo_estado
ON reservas_demo (estado_reserva);

CREATE INDEX IF NOT EXISTS idx_reservas_demo_session
ON reservas_demo (session_id);