# Prompts del Proyecto

Esta carpeta contiene prompts y reglas utilizadas para organizar la lógica del workflow del proyecto **ClaustroSF**.

---

## Estructura

```text
prompts/
├── prompt_asistente_hotelero.md
├── prompt_cursor.md
├── prompt_kiro.md
├── README.md
└── system/
    ├── system_documental.md
    ├── system_reservas.md
    ├── system_consultoria.md
    ├── reglas_seguridad.md
    └── reglas_clasificacion.md
```

---

## Propósito

La carpeta `system/` separa las reglas del sistema por responsabilidad.

Esto permite que el proyecto sea más fácil de mantener, explicar y escalar.

---

## Archivos principales

### `system_documental.md`

Reglas para responder consultas documentales usando documentos del hotel.

### `system_reservas.md`

Reglas para solicitudes de reserva y futuras mejoras de disponibilidad.

### `system_consultoria.md`

Reglas para recomendaciones y asesoría hotelera.

### `reglas_seguridad.md`

Reglas para bloquear solicitudes sensibles o fuera de alcance.

### `reglas_clasificacion.md`

Criterios para clasificar preguntas y decidir qué módulo debe ejecutarse.

---

## Estado actual

En esta versión, los archivos funcionan como referencia modular de reglas.

En futuras versiones, n8n podrá leerlos desde GitHub RAW para cargar dinámicamente las reglas del sistema.