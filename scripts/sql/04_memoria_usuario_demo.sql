CREATE TABLE IF NOT EXISTS memoria_usuario_demo (
    id SERIAL PRIMARY KEY,

    session_id TEXT NOT NULL UNIQUE,

    nombre_usuario TEXT,

    numero_adultos INTEGER CHECK (numero_adultos IS NULL OR numero_adultos >= 0),
    numero_ninos INTEGER CHECK (numero_ninos IS NULL OR numero_ninos >= 0),

    tipo_habitacion_preferida TEXT CHECK (
        tipo_habitacion_preferida IS NULL
        OR tipo_habitacion_preferida IN ('sencilla', 'doble', 'triple', 'familiar', 'suite')
    ),

    vista_preferida TEXT,

    presupuesto_max_cop NUMERIC(12, 2) CHECK (
        presupuesto_max_cop IS NULL
        OR presupuesto_max_cop >= 0
    ),

    preferencias_texto TEXT,

    ultima_pregunta TEXT,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_memoria_usuario_demo_session
ON memoria_usuario_demo (session_id);

CREATE INDEX IF NOT EXISTS idx_memoria_usuario_demo_nombre
ON memoria_usuario_demo (nombre_usuario);

CREATE INDEX IF NOT EXISTS idx_memoria_usuario_demo_tipo_habitacion
ON memoria_usuario_demo (tipo_habitacion_preferida);