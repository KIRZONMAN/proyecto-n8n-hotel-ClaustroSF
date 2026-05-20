# Plan de trabajo

Proyecto académico **Reception Agent ClaustroSF**, desarrollado para el **Hotel El Claustro de San Francisco**.

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

Abreviatura usada:

```text
ClaustroSF
```

Curso:

```text
Modelado Computacional
```

---

## 1. Objetivo general del proyecto

Construir un asistente hotelero académico en n8n capaz de simular tareas de recepción mediante automatización, IA local y PostgreSQL.

El sistema busca responder preguntas del hotel, consultar datos, recordar preferencias del usuario y registrar reservas demo de forma controlada.

---

## 2. Alcance actual

El proyecto actualmente incluye:

- Entrada manual de preguntas en n8n.
- Normalización de texto.
- Clasificación de intención.
- Enrutamiento por tipo de solicitud.
- Consulta documental con IA local.
- Optimización del contexto documental.
- Analítica del dataset hotelero.
- Consulta de disponibilidad de habitaciones.
- Memoria personalizada por sesión.
- Reserva demo inteligente.
- Validación de capacidad, disponibilidad y presupuesto.
- Registro de reservas demo en PostgreSQL.
- Respuestas seguras ante solicitudes fuera de alcance.
- Separación visual del workflow por zonas.

---

## 3. Fases del proyecto

| Fase | Nombre | Descripción | Estado |
|---|---|---|---|
| Fase 1 | Infraestructura base | Levantar entorno con Docker, n8n, PostgreSQL y Ollama. | Completada |
| Fase 2 | Asistente documental inicial | Crear una primera versión capaz de responder preguntas usando el documento base del hotel. | Completada |
| Fase 3 | Clasificación y enrutamiento | Normalizar preguntas, clasificar intención y enrutar con `Switch - Tipo de solicitud`. | Completada |
| Fase 4 | Reserva demo inteligente | Extraer datos de reserva, consultar habitaciones, validar disponibilidad y registrar reservas demo. | Completada |
| Fase 5 | Memoria personalizada | Guardar preferencias del usuario con enfoque `IA interpreta → Code valida → PostgreSQL guarda`. | Completada |
| Fase 6 | Optimización de tokens y precisión | Reducir contexto documental, mejorar clasificación y evitar llamadas innecesarias a IA. | En curso / casi cerrada |
| Fase 7 | Documentación y evidencias | Actualizar archivos del repositorio, registrar avances y preparar entrega. | En curso |
| Fase futura | Consultoría hotelera avanzada | Recomendar habitaciones según perfil, memoria, presupuesto y disponibilidad. | Pendiente |
| Fase futura | Canales externos | Integrar Telegram, WhatsApp u otros canales. | Pendiente |
| Fase futura | RAG avanzado | Integrar búsqueda vectorial, documentos múltiples o base de conocimiento más grande. | Pendiente |

---

## 4. Arquitectura de trabajo actual

El workflow se divide en siete zonas funcionales:

```text
Zona 1 — Entrada y clasificación
Zona 2 — Consulta documental con IA
Zona 3 — Analítica del dataset
Zona 4 — Reserva demo inteligente
Zona 5 — Respuesta segura / excepciones
Zona 6 — Disponibilidad simple
Zona 7 — Memoria personalizada
```

Esta división permite explicar el proyecto de forma clara durante la sustentación.

---

## 5. Flujo general del sistema

El flujo inicia con:

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

A partir del `Switch`, el sistema envía la solicitud al módulo correspondiente:

| Tipo de solicitud | Módulo |
|---|---|
| `documental` | Consulta documental con IA |
| `analitica_dataset` | Analítica del dataset |
| `reserva_simulada` | Reserva demo inteligente |
| `fuera_alcance` | Respuesta segura |
| `disponibilidad_habitaciones` | Disponibilidad simple |
| `consultoria` | Respuesta segura como módulo pendiente |
| `memoria_usuario` | Memoria personalizada |

---

## 6. Fase 1 — Infraestructura base

Objetivo:

```text
Tener un entorno local funcional para ejecutar n8n, PostgreSQL y Ollama.
```

Componentes:

- Docker / Docker Compose.
- n8n.
- PostgreSQL.
- Ollama.
- Modelo local `llama3:latest`.

Estado:

```text
Completado.
```

---

## 7. Fase 2 — Asistente documental inicial

Objetivo:

```text
Responder preguntas del hotel usando documentación propia.
```

Resultado actual:

- El documento base se obtiene desde GitHub RAW.
- El sistema prepara un contexto documental reducido.
- El `AI Agent` responde usando solo ese contexto.
- La salida se limpia y se formatea con un nodo Code.

Ruta:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

Estado:

```text
Completado y optimizado.
```

---

## 8. Fase 3 — Clasificación y enrutamiento

Objetivo:

```text
Clasificar la intención del usuario sin depender de IA.
```

Resultado actual:

- El nodo `Code - Clasificar Intención` identifica la intención mediante reglas.
- El nodo `Switch - Tipo de solicitud` enruta la petición a la zona correcta.
- Se evita llamar IA cuando la solicitud puede resolverse con PostgreSQL o código.

Estado:

```text
Completado.
```

---

## 9. Fase 4 — Reserva demo inteligente

Objetivo:

```text
Permitir que el asistente registre reservas demo de forma controlada.
```

Funciones implementadas:

- Extracción de tipo de habitación.
- Extracción de número de personas.
- Extracción de número de noches.
- Extracción de fecha de entrada básica.
- Consulta de memoria del usuario.
- Aplicación de memoria para completar datos faltantes.
- Validación de datos mínimos.
- Búsqueda de habitación disponible.
- Validación de presupuesto.
- Registro de reserva demo.
- Cambio de estado de habitación a `reservada`.

Ruta principal:

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

Estado:

```text
Completado como reserva demo académica.
```

---

## 10. Fase 5 — Memoria personalizada

Objetivo:

```text
Guardar información útil del usuario para reutilizarla en futuras reservas o consultas.
```

Enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

Datos que puede recordar:

- Nombre del usuario.
- Número de adultos.
- Número de niños.
- Tipo de habitación preferida.
- Vista preferida.
- Presupuesto máximo por noche.
- Preferencias generales.

Ruta:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
   ├── false → Code - Memoria No Guardada
   └── true
       → Postgres - Guardar Memoria Usuario
       → Code - Confirmar Memoria Guardada
```

Estado:

```text
Completado y conectado.
```

Nota:

```text
La IA no guarda directamente en la base de datos.
La IA no ejecuta SQL.
La IA solo propone JSON.
El código valida antes de guardar.
```

---

## 11. Fase 6 — Optimización de tokens y precisión

Objetivo:

```text
Reducir costos computacionales, evitar llamadas innecesarias a IA y mejorar la precisión de las respuestas.
```

Mejoras implementadas o en proceso:

- Clasificación previa con reglas.
- Solo se llama IA en módulos que realmente la necesitan.
- El módulo documental reduce el documento completo a un contexto relevante.
- La analítica, disponibilidad y reserva trabajan con PostgreSQL y Code.
- La memoria usa IA solo para extracción semántica, no para acciones críticas.
- Los módulos sensibles tienen validación y respuestas seguras.

Estado:

```text
En curso / casi cerrada.
```

---

## 12. Fase 7 — Documentación y evidencias

Objetivo:

```text
Dejar el repositorio alineado con el estado real del workflow.
```

Archivos a actualizar:

```text
README.md
workflows/README.md
docs/README.md
docs/arquitectura.md
docs/plan_trabajo.md
docs/pruebas_funcionales.md
docs/explicacion_demo.md
docs/memoria_usuario.md
docs/riesgos_y_limitaciones.md
control/checklist_entrega.md
control/avances_rtx.md
evidencias/README.md
```

Estado:

```text
En curso.
```

---

## 13. Trabajo pendiente

Pendientes principales:

- Separar la consultoría hotelera en un módulo propio.
- Completar más pruebas documentadas.
- Actualizar evidencias visuales.
- Reexportar el workflow final desde n8n.
- Revisar que el JSON exportado no tenga credenciales.
- Preparar el guion final de sustentación.
- Confirmar que la documentación no mencione versiones antiguas como flujo principal.

---

## 14. Declaración de alcance para defensa

El proyecto actual es una simulación académica de recepción hotelera.

No debe presentarse como sistema productivo real.

Actualmente sí incluye:

```text
IA local
PostgreSQL
memoria personalizada
reservas demo
analítica
disponibilidad
consulta documental
clasificación
respuestas seguras
```

Actualmente no incluye:

```text
pagos reales
integración con PMS hotelero real
envío real de correos
canales como WhatsApp o Telegram
autenticación de usuarios reales
RAG vectorial avanzado
consultoría hotelera completamente implementada
```