# Avances recibidos desde la PC RTX 3050

Este archivo registra el avance técnico trabajado desde la máquina principal de ejecución del proyecto.

Proyecto:

```text
Reception Agent ClaustroSF
```

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

---

## RTX CHECKPOINT 1 — Infraestructura base

Estado:

```text
Completado / operativo
```

Elementos trabajados:

- Docker como entorno de ejecución.
- n8n como motor de automatización.
- PostgreSQL como base de datos.
- Ollama como motor de IA local.
- Modelo local usado actualmente: `llama3:latest`.

Resultado:

```text
El entorno permite ejecutar workflows de n8n conectados con PostgreSQL y Ollama.
```

---

## RTX CHECKPOINT 2 — Primer asistente documental

Estado:

```text
Superado por versiones posteriores
```

Descripción:

Inicialmente se trabajó una versión más simple del asistente, basada en un flujo directo para responder preguntas del hotel usando Ollama.

Esa versión ya no representa el estado actual del proyecto.

Resultado:

```text
Sirvió como base para validar la comunicación entre n8n y Ollama.
```

---

## RTX CHECKPOINT 3 — Clasificación de intención

Estado:

```text
Completado
```

Se implementó una fase de entrada y clasificación compuesta por:

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

El sistema clasifica solicitudes en:

```text
documental
analitica_dataset
reserva_simulada
fuera_alcance
disponibilidad_habitaciones
consultoria
memoria_usuario
```

Resultado:

```text
El workflow ya no depende de IA para decidir la ruta principal. La clasificación se realiza con reglas y puntajes.
```

---

## RTX CHECKPOINT 4 — Organización por zonas

Estado:

```text
Completado
```

El workflow fue organizado visualmente en siete zonas:

```text
Zona 1 — Entrada y clasificación
Zona 2 — Módulo de consulta documental con IA
Zona 3 — Módulo de analítica del dataset
Zona 4 — Módulo de reserva
Zona 5 — Respuesta segura / excepción
Zona 6 — Módulo de disponibilidad simple
Zona 7 — Módulo de memoria personalizada
```

Resultado:

```text
La organización visual facilita explicar el proyecto durante la sustentación.
```

---

## RTX CHECKPOINT 5 — Consulta documental con IA

Estado:

```text
Completado y optimizado
```

Ruta actual:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

Mejoras realizadas:

- El documento base se consume desde GitHub RAW.
- Se usa `Documento_Base_Hotel.md`.
- Se agregó preparación de contexto documental.
- Se evita enviar todo el documento completo cuando no es necesario.
- Se optimizó el uso de tokens.
- El agente responde usando únicamente el contexto proporcionado.

Resultado probado:

```text
Pregunta sobre políticas de cancelación clasificada como documental y respondida por el agente.
```

---

## RTX CHECKPOINT 6 — Analítica del dataset

Estado:

```text
Completado
```

Ruta actual:

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

El módulo consulta métricas como:

- Total de reservas.
- Tasa de cancelación.
- ADR promedio.
- Lead time promedio.
- Reservas por tipo de hotel.
- Mes con más reservas.
- Segmento más frecuente.

Resultado probado:

```text
La pregunta "Muéstrame métricas del dataset" se enruta correctamente a analítica y devuelve resumen calculado desde PostgreSQL.
```

---

## RTX CHECKPOINT 7 — Disponibilidad simple

Estado:

```text
Completado
```

Ruta actual:

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

El módulo permite consultar disponibilidad por tipo de habitación.

Resultado probado:

```text
La pregunta "¿Hay habitaciones familiares disponibles?" se enruta correctamente a disponibilidad y consulta PostgreSQL.
```

---

## RTX CHECKPOINT 8 — Reserva demo inteligente

Estado:

```text
Completado como simulación académica
```

Ruta general:

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
→ Code - Validar Reserva Completa
→ Code - Preparar Consulta Reserva
→ Postgres - Buscar Habitación Disponible
→ If - ¿Hay disponibilidad?
→ If - ¿Cumple presupuesto?
→ Code - Preparar Registro Reserva
→ Postgres - Registrar Reserva Demo
→ Code - Confirmar Reserva Registrada
```

Funciones logradas:

- Extrae datos de reserva.
- Consulta memoria previa.
- Completa datos faltantes con memoria.
- Valida datos mínimos.
- Busca habitación disponible.
- Verifica capacidad.
- Verifica presupuesto máximo.
- Registra reserva demo.
- Cambia habitación a estado `reservada`.

Resultado probado:

```text
Se registraron reservas demo correctamente con código de reserva generado.
```

---

## RTX CHECKPOINT 9 — Memoria personalizada

Estado:

```text
Completado
```

Ruta actual:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
   ├── false → Code - Memoria No Guardada
   └── true
       → Postgres - Guardar Memoria Usuario
       → Code - Confirmar Memoria Guardada
```

Enfoque implementado:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

Datos que puede guardar:

- Nombre del usuario.
- Número de adultos.
- Número de niños.
- Tipo de habitación preferida.
- Vista preferida.
- Presupuesto máximo por noche.
- Preferencias generales.

Mejoras realizadas:

- La IA devuelve JSON.
- El código valida antes de guardar.
- Se descartan campos dudosos o inválidos.
- Se evita guardar interpretaciones inseguras.
- PostgreSQL persiste los datos por `session_id`.

Resultado probado:

```text
Se guardó memoria de usuario y también se descartaron campos inválidos cuando correspondía.
```

---

## RTX CHECKPOINT 10 — Optimización y corrección de rutas

Estado:

```text
En curso / casi cerrado
```

Mejoras recientes:

- Se corrigió la clasificación de intenciones.
- Se ajustó el `Switch - Tipo de solicitud`.
- Se confirmó que las ramas con IA son principalmente documental y memoria.
- Se confirmó que analítica, disponibilidad y reserva trabajan con PostgreSQL y Code.
- Se documentó que `consultoria` existe como intención, pero todavía no tiene módulo propio.

Resultado:

```text
El workflow quedó más estable y defendible, evitando que preguntas simples pasen innecesariamente por IA.
```

---

## RTX CHECKPOINT 10.1 — Documentación del avance actual

Estado:

```text
En curso
```

Objetivo actual:

```text
Actualizar los documentos del repositorio para que coincidan con el workflow real.
```

Documentos de primera tanda:

```text
workflows/README.md
docs/plan_trabajo.md
control/checklist_entrega.md
control/avances_rtx.md
docs/README.md
```

Pendiente después de esta tanda:

```text
docs/arquitectura.md
docs/pruebas_funcionales.md
docs/explicacion_demo.md
docs/memoria_usuario.md
docs/riesgos_y_limitaciones.md
README.md
evidencias/README.md
evidencias/pendientes.txt
documentos/Preguntas_Prueba_Hotel.md
```

---

## Estado global del proyecto en este checkpoint

El proyecto ya puede describirse como:

```text
Asistente hotelero académico avanzado con n8n, PostgreSQL, Ollama, consulta documental, analítica, disponibilidad, memoria personalizada y reserva demo inteligente.
```

No debe describirse como:

```text
Flujo básico Code Node → Ollama
```

Tampoco debe describirse como sistema productivo real.

---

## Pendientes técnicos principales

- [ ] Exportar el workflow final actualizado desde n8n.
- [ ] Revisar que el JSON exportado no tenga credenciales.
- [ ] Actualizar segunda tanda de documentación.
- [ ] Agregar o seleccionar evidencias visuales finales.
- [ ] Revisar documentación para eliminar referencias obsoletas a `qwen2.5:7b`.
- [ ] Revisar documentación para eliminar referencias al flujo antiguo como flujo principal.
- [ ] Dejar claro que consultoría avanzada está pendiente.