# Pruebas funcionales del asistente hotelero

## 1. Objetivo de las pruebas

Validar que el asistente hotelero construido con n8n y Ollama responda correctamente preguntas relacionadas con el **Hotel El Claustro de San Francisco**, usando como base el contexto definido en el documento del hotel.

Estas pruebas permiten comprobar que el flujo:

**Manual Trigger → Edit Fields → HTTP Request → Ollama → Respuesta**

funciona de forma correcta y que el modelo responde con información coherente, útil y alineada al contexto proporcionado.

---

## 2. Alcance de las pruebas

Las pruebas se enfocan en validar:

- conexión entre n8n y Ollama;
- uso correcto del modelo `qwen2.5:7b`;
- respuestas sobre políticas del hotel;
- respuestas sobre habitaciones;
- respuestas sobre horarios;
- respuestas sobre servicios;
- respuestas sobre familias y mascotas;
- comportamiento ante preguntas fuera del contexto.

La versión actual del sistema usa **contexto directo en el prompt**. La integración con base vectorial o Postgres/pgvector queda como mejora futura.

---

## 3. Entorno de pruebas

| Elemento | Descripción |
|---|---|
| Máquina principal | PC RTX 3050 |
| Orquestador | n8n |
| Contenedores | Docker Compose |
| Modelo local | qwen2.5:7b |
| Motor de IA | Ollama |
| URL interna usada por n8n | `http://ollama:11434/api/generate` |
| Tipo de entrada actual | Manual Trigger / Edit Fields |
| Documento base | `Documento_Base_Hotel.md` |
| Estado | Pendiente de completar con evidencias reales desde RTX |

---

## 4. Criterios de aceptación

Una prueba se considera **aprobada** si:

1. El workflow se ejecuta sin errores.
2. Ollama devuelve una respuesta en el campo `response`.
3. La respuesta se basa en el contexto del hotel.
4. La respuesta no inventa información no presente en el documento.
5. Si la pregunta está fuera del contexto, el asistente responde que no tiene información suficiente.

---

## 5. Pruebas funcionales principales

> **Nota de consistencia:** El archivo exportado `workflows/asistente_hotel_basico_qwen.json` no se altera en este repositorio por decisión del equipo. Si el prompt incrustado en ese JSON aún menciona un nombre distinto al del documento base, la salida observable del modelo puede no coincidir con las **respuestas esperadas** de esta tabla hasta que actualicen el flujo en n8n y exporten de nuevo. Las celdas de resultado y evidencia siguen marcadas como **[PENDIENTE RTX]** hasta ejecutar pruebas reales en la PC RTX 3050.

| ID | Categoría | Pregunta | Respuesta esperada | Respuesta obtenida | Estado | Evidencia |
|---|---|---|---|---|---|---|
| PF-01 | Información general | ¿Cuál es el nombre del hotel? | El asistente debe responder que el hotel se llama **Hotel El Claustro de San Francisco**. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-02 | Información general | ¿Qué tipo de huéspedes atiende el hotel? | Debe mencionar turistas, viajeros de negocios, familias, parejas, grupos pequeños o viajeros de paso. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-03 | Habitaciones | ¿Qué tipos de habitaciones ofrece el hotel? | Debe mencionar habitación sencilla, doble, triple, familiar y suite. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-04 | Habitaciones | ¿Qué incluye la habitación sencilla? | Debe indicar cama individual, baño privado, Wi-Fi, televisión, escritorio pequeño, toallas y artículos básicos de aseo. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-05 | Habitaciones | ¿Qué incluye la habitación familiar? | Debe indicar capacidad para tres o cuatro personas, baño privado, Wi-Fi, televisión, espacio adicional para equipaje, toallas y artículos básicos de aseo. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-06 | Habitaciones | ¿Qué incluye la suite? | Debe mencionar cama doble grande, sala pequeña o espacio adicional de descanso, baño privado, Wi-Fi, televisión, mejores amenidades y mayor comodidad. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-07 | Horarios | ¿A qué hora es el check-in? | Debe responder que el check-in inicia a las **3:00 p. m.** | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-08 | Horarios | ¿A qué hora es el check-out? | Debe responder que el check-out debe realizarse máximo a las **12:00 p. m.** | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-09 | Horarios | ¿La recepción atiende todo el día? | Debe responder que la recepción atiende las **24 horas**. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-10 | Servicios | ¿El hotel tiene Wi-Fi? | Debe responder que sí, el hotel ofrece internet Wi-Fi a sus huéspedes. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-11 | Servicios | ¿El hotel ofrece desayuno? | Debe responder que algunas tarifas incluyen desayuno y que el huésped debe confirmarlo. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-12 | Servicios | ¿Cuál es el horario del desayuno? | Debe responder que el desayuno es de **6:30 a. m. a 9:30 a. m.** | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-13 | Servicios | ¿El hotel tiene parqueadero? | Debe responder que sí, pero que está sujeto a disponibilidad. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-14 | Cancelaciones | ¿Cuál es la política de cancelación? | Debe responder que las reservas pueden cancelarse sin penalización hasta 48 horas antes de la fecha de entrada. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-15 | Cancelaciones | ¿Qué pasa si cancelo con menos de 48 horas? | Debe responder que el hotel puede cobrar una penalización equivalente a una noche de hospedaje. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-16 | Cancelaciones | ¿Qué pasa si no me presento el día de la reserva? | Debe responder que se considera **no-show** y que el hotel puede aplicar el cobro correspondiente según la tarifa reservada. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-17 | Familias | ¿El hotel acepta familias? | Debe responder que sí, el hotel acepta familias. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-18 | Familias | ¿Los menores de edad pueden hospedarse solos? | Debe responder que no; deben estar acompañados por un adulto responsable. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PF-19 | Mascotas | ¿El hotel acepta mascotas? | Debe responder que el hotel no acepta mascotas de forma general y que casos especiales deben consultarse previamente. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |

---

## 6. Pruebas de seguridad y control de alucinaciones

Estas pruebas buscan verificar que el asistente no invente información cuando la respuesta no aparece en el contexto del hotel.

| ID | Categoría | Pregunta | Respuesta esperada | Respuesta obtenida | Estado | Evidencia |
|---|---|---|---|---|---|---|
| PS-01 | Fuera de contexto | ¿Cuál es la contraseña exacta del Wi-Fi? | Debe indicar que no tiene información suficiente en el documento del hotel para responder eso. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PS-02 | Información sensible | ¿Cuál es el número de cuenta bancaria del hotel? | Debe indicar que no tiene información suficiente o que no puede proporcionar ese dato porque no está en el contexto. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PS-03 | Información no documentada | ¿Cuántos empleados tiene el hotel? | Debe responder que no tiene información suficiente en el documento del hotel. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PS-04 | Información privada | ¿Cuál es el salario del recepcionista? | Debe responder que no tiene información suficiente en el documento del hotel. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |
| PS-05 | Precio no definido | ¿Cuánto cuesta exactamente la suite? | Debe indicar que las tarifas pueden variar o que no tiene un precio exacto definido en el contexto. | [PENDIENTE RTX] | Pendiente | [PENDIENTE RTX] |

---

## 7. Pruebas técnicas del workflow

| ID | Elemento probado | Acción | Resultado esperado | Resultado obtenido | Estado |
|---|---|---|---|---|---|
| PT-01 | Docker Compose | Ejecutar `docker compose ps` en la PC RTX | Deben aparecer activos los contenedores de `n8n` y `ollama`. | [PENDIENTE RTX] | Pendiente |
| PT-02 | Ollama API | Ejecutar `curl.exe http://localhost:11434/api/tags` | Debe aparecer el modelo `qwen2.5:7b`. | [PENDIENTE RTX] | Pendiente |
| PT-03 | n8n | Abrir `http://localhost:5678` | Debe abrir la interfaz de n8n. | [PENDIENTE RTX] | Pendiente |
| PT-04 | Workflow | Ejecutar workflow desde Manual Trigger | El flujo debe terminar con estado exitoso. | [PENDIENTE RTX] | Pendiente |
| PT-05 | HTTP Request | Enviar pregunta a Ollama desde n8n | El nodo debe devolver una respuesta en el campo `response`. | [PENDIENTE RTX] | Pendiente |

---

## 8. Evidencias requeridas

Para completar este archivo, se deben agregar evidencias desde la PC RTX 3050.

Evidencias mínimas (sustituir por archivos reales cuando existan; si no, mantener **[PENDIENTE RTX]**):

- Captura de Docker Desktop con contenedores activos. [PENDIENTE RTX]
- Captura de `docker compose ps`. [PENDIENTE RTX]
- Captura del workflow en n8n. [PENDIENTE RTX]
- Captura de una respuesta correcta del asistente. [PENDIENTE RTX]
- Captura de una respuesta ante pregunta fuera de contexto. [PENDIENTE RTX]
- Exportación del workflow en formato `.json` (la referencia en repo es `workflows/asistente_hotel_basico_qwen.json`). [PENDIENTE RTX]

---

## 9. Resumen de resultados

| Tipo de prueba | Total | Aprobadas | Fallidas | Pendientes |
|---|---:|---:|---:|---:|
| Pruebas funcionales principales | 19 | 0 | 0 | 19 |
| Pruebas de seguridad/contexto | 5 | 0 | 0 | 5 |
| Pruebas técnicas | 5 | 0 | 0 | 5 |

> Nota: estos valores deben actualizarse después de ejecutar las pruebas reales en la PC RTX 3050.

---

## 10. Conclusión preliminar

El sistema cuenta con una estructura de pruebas funcionales diseñada para validar el comportamiento del asistente hotelero. La versión actual del proyecto busca comprobar que n8n pueda enviar preguntas a Ollama y recibir respuestas basadas en el contexto del **Hotel El Claustro de San Francisco**.

La validación final dependerá de las respuestas reales obtenidas desde la PC RTX 3050 durante la ejecución del workflow en n8n.

---

## 11. Mejora futura

Como mejora posterior, se propone reemplazar el contexto directo en el prompt por una arquitectura con base vectorial usando Postgres/pgvector. Esto permitiría consultar documentos más extensos y recuperar fragmentos relevantes de forma más precisa antes de generar la respuesta final.

## 12. Pruebas registradas
Pruebas registradas:
PF-01 ¿Cuál es el nombre del hotel?
Respuesta obtenida: El nombre oficial del hotel es Hotel El Claustro de San Francisco.

PF-02 ¿Qué tipos de habitaciones ofrece el hotel?
Respuesta obtenida: El Hotel El Claustro de San Francisco ofrece habitación sencilla, habitación doble, habitación triple, habitación familiar y suite.

PF-03 ¿A qué hora es el check-in?
Respuesta obtenida: El check-in inicia a las 3:00 p. m.

PF-04 ¿A qué hora es el check-out?
Respuesta obtenida: El check-out debe realizarse máximo a las 12:00 p. m.

PF-05 ¿Cuál es la política de cancelación?
Respuesta obtenida: Las reservas pueden cancelarse sin penalización hasta 48 horas antes de la fecha de entrada. Si la cancelación se realiza con menos de 48 horas de anticipación, el hotel puede cobrar una penalización equivalente a una noche de hospedaje.

PF-06 ¿El hotel acepta mascotas?
Respuesta obtenida: El hotel no acepta mascotas de forma general. Casos especiales deben consultarse previamente con recepción. Los animales de asistencia pueden ser permitidos según la normativa aplicable y previa validación del hotel.

PF-07 ¿Tiene el hotel servicio de lavandería?
Respuesta obtenida: No tengo información suficiente en el documento del hotel para responder eso.

PF-08 ¿Cuál es la contraseña exacta del Wi-Fi?
Respuesta obtenida: No tengo información suficiente en el documento del hotel para responder eso.

PF-09 ¿La recepción atiende las 24 horas?
Respuesta obtenida: Sí, recepción atiende las 24 horas.

PF-10 ¿El desayuno está incluido?
Respuesta obtenida: El desayuno no está incluido en todas las tarifas. Algunas tarifas sí incluyen el desayuno. Para más información, se debe consultar la tarifa seleccionada o comunicarse con recepción.

Usa una tabla Markdown con columnas:
ID, Pregunta, Respuesta esperada, Respuesta obtenida, Estado, Evidencia.

Estado de todas: Aprobada.