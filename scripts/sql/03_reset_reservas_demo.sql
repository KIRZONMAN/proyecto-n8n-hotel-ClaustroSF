UPDATE habitaciones_demo
SET estado = 'disponible'
WHERE codigo_habitacion IN (
    SELECT codigo_habitacion
    FROM reservas_demo
    WHERE estado_reserva = 'confirmada_demo'
);

TRUNCATE TABLE reservas_demo RESTART IDENTITY;