# Explicación para demo

Proyecto:

```text
Reception Agent ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

---

## 1. Introducción para presentar

Este proyecto es un asistente hotelero académico construido en n8n.

Su objetivo es simular una recepción inteligente capaz de responder preguntas, consultar datos, revisar disponibilidad, recordar preferencias del usuario y registrar reservas demo.

El sistema integra:

- n8n para automatización.
- PostgreSQL para almacenamiento y consultas.
- Ollama para IA local.
- `llama3:latest` como modelo de lenguaje.
- JavaScript para validaciones y lógica.
- SQL para consultas y persistencia.
- GitHub RAW para cargar el documento base del hotel.

---

## 2. Problema que aborda

En una recepción hotelera existen tareas repetitivas como:

- Responder políticas de cancelación.
- Explicar servicios del hotel.
- Consultar disponibilidad.
- Revisar precios o tipos de habitación.
- Registrar reservas.
- Recordar preferencias del huésped.
- Atender solicitudes fuera de alcance de forma segura.

Este proyecto automatiza parte de esas tareas mediante un workflow modular.

---

## 3. Idea principal del sistema

El asistente recibe una pregunta del usuario y primero decide qué tipo de solicitud es.

Luego el sistema la envía al módulo correcto:

```text
documental
analítica
reserva
disponibilidad
memoria
fuera de alcance
consultoría pendiente
```

Esto evita que todas las preguntas pasen por IA y hace el sistema más eficiente.

---

## 4. Estructura visual del workflow

El workflow está separado en siete zonas:

```text
Zona 1 — Entrada y clasificación
Zona 2 — Consulta documental con IA
Zona 3 — Analítica del dataset
Zona 4 — Reserva demo inteligente
Zona 5 — Respuesta segura / excepciones
Zona 6 — Disponibilidad simple
Zona 7 — Memoria personalizada
```

Esta organización permite explicar cada parte del sistema sin perderse en todo el flujo.

---

## 5. Zona 1 — Entrada y clasificación

La primera zona recibe la pregunta y la clasifica.

Ruta:

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

Aquí se genera:

```text
tipo_solicitud
confianza_clasificacion
motivo_clasificacion
score_clasificacion
```

El `Switch` decide a qué módulo enviar la solicitud.

---

## 6. Salidas del Switch

| Output | Tipo de solicitud | Módulo |
|---|---|---|
| 0 | `documental` | Consulta documental con IA |
| 1 | `analitica_dataset` | Analítica del dataset |
| 2 | `reserva_simulada` | Reserva demo inteligente |
| 3 | `fuera_alcance` | Respuesta segura |
| 4 | `disponibilidad_habitaciones` | Disponibilidad simple |
| 5 | `consultoria` | Respuesta segura temporal |
| 6 | `memoria_usuario` | Memoria personalizada |

---

## 7. Demo recomendada: orden de presentación

Para la demo, se recomienda mostrar el sistema en este orden:

```text
1. Consulta documental
2. Analítica del dataset
3. Disponibilidad simple
4. Memoria personalizada
5. Reserva demo
6. Respuesta segura
7. Consultoría como módulo pendiente
```

Este orden permite mostrar primero módulos simples y luego los más avanzados.

---

## 8. Prueba 1 — Consulta documental

Entrada:

```text
¿Cuáles son las políticas de cancelación del hotel?
```

Qué demuestra:

- Clasificación documental.
- Lectura del documento base.
- Preparación de contexto documental.
- Respuesta con IA local.
- Uso controlado del documento.

Ruta:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

Explicación sugerida:

```text
En esta prueba, el sistema identifica que la pregunta es documental. Luego obtiene el documento base del hotel desde GitHub RAW, selecciona las secciones relevantes y entrega ese contexto al agente IA. El agente responde únicamente con base en ese contexto.
```

---

## 9. Prueba 2 — Analítica del dataset

Entrada:

```text
Muéstrame métricas del dataset
```

Qué demuestra:

- Clasificación como analítica.
- Consulta SQL en PostgreSQL.
- Respuesta sin IA.
- Cálculo de métricas.

Ruta:

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

Explicación sugerida:

```text
Este módulo no usa IA. El sistema consulta PostgreSQL directamente y devuelve métricas calculadas del dataset hotelero, como total de reservas, tasa de cancelación, ADR promedio y lead time promedio.
```

---

## 10. Prueba 3 — Disponibilidad simple

Entrada:

```text
¿Hay habitaciones familiares disponibles?
```

Qué demuestra:

- Clasificación como disponibilidad.
- Consulta directa a PostgreSQL.
- Respuesta rápida sin IA.
- Separación entre disponibilidad simple y reserva.

Ruta:

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

Explicación sugerida:

```text
Aquí el sistema no necesita IA. Solo consulta la tabla de habitaciones demo y devuelve un resumen de disponibilidad para el tipo solicitado.
```

---

## 11. Prueba 4 — Memoria personalizada

Entrada:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Qué demuestra:

- Detección de memoria de usuario.
- Extracción con IA.
- Validación con código.
- Guardado en PostgreSQL.
- Descarte de campos erróneos.

Ruta:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
→ Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

Explicación sugerida:

```text
La IA interpreta la frase y propone un JSON. Luego un nodo Code valida que los datos sean confiables antes de guardarlos. Esto evita que una interpretación errónea de la IA llegue directamente a la base de datos.
```

Punto importante para explicar:

```text
La IA solo propone. El sistema valida antes de guardar.
```

---

## 12. Prueba 5 — Reserva demo

Entrada:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Qué demuestra:

- Clasificación como reserva.
- Extracción de datos de reserva.
- Consulta de memoria.
- Validación de datos.
- Consulta de disponibilidad.
- Validación de presupuesto.
- Registro demo.

Ruta resumida:

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
→ Postgres - Buscar Habitación Disponible
→ If - ¿Hay disponibilidad?
→ If - ¿Cumple presupuesto?
→ Postgres - Registrar Reserva Demo
→ Code - Confirmar Reserva Registrada
```

Explicación sugerida:

```text
En este caso, el sistema no usa IA para registrar la reserva. La lógica de negocio se maneja con Code y PostgreSQL. Esto permite validar datos, disponibilidad y presupuesto antes de registrar cualquier reserva demo.
```

---

## 13. Prueba 6 — Respuesta segura

Entrada:

```text
Cuéntame un chiste
```

Qué demuestra:

- Detección de fuera de alcance.
- Respuesta controlada.
- Evita usar IA innecesariamente.

Ruta:

```text
Code - Respuesta Segura
```

Explicación sugerida:

```text
El sistema detecta que la pregunta no corresponde al dominio hotelero y responde de forma segura sin usar módulos innecesarios.
```

---

## 14. Prueba 7 — Consultoría pendiente

Entrada:

```text
¿Qué habitación me recomiendas para viajar con mi familia?
```

Qué demuestra:

- La intención consultoría ya está clasificada.
- El módulo especializado todavía está pendiente.
- El sistema no falla, sino que responde de forma controlada.

Estado actual:

```text
tipo_solicitud = consultoria
```

Ruta actual:

```text
Code - Respuesta Segura
```

Explicación sugerida:

```text
La consultoría hotelera ya se reconoce como intención, pero aún no tiene módulo propio. Por ahora se responde de manera segura y queda como mejora futura.
```

---

## 15. Puntos fuertes para destacar

Durante la presentación conviene resaltar:

- El workflow está dividido por zonas.
- No todo pasa por IA.
- La clasificación se hace antes de llamar agentes.
- Las consultas SQL no usan IA.
- La reserva no la decide la IA.
- La memoria se valida antes de guardarse.
- El documento se reduce antes de enviarse al agente.
- El sistema maneja errores con respuestas controladas.
- El proyecto usa IA local con Ollama.

---

## 16. Cómo explicar la optimización de tokens

Antes:

```text
El agente podía recibir mucho contexto documental.
```

Ahora:

```text
HTTP Request obtiene el documento.
Code - Preparar Contexto Documental selecciona partes relevantes.
AI Agent recibe solo el contexto necesario.
```

Explicación sencilla:

```text
Esto reduce la cantidad de texto enviada al modelo y mejora la precisión de la respuesta.
```

---

## 17. Cómo explicar la memoria personalizada

La memoria personalizada sigue este enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

Ejemplo:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

El sistema guarda:

```text
nombre_usuario = Hector
preferencias_texto = habitaciones tranquilas
```

Pero si la IA propone algo incorrecto, como:

```text
vista_preferida = tranquilas
```

el nodo de validación lo descarta.

---

## 18. Cómo explicar las reservas

El módulo de reserva usa:

```text
Code
PostgreSQL
If
Switch
```

No depende de IA para registrar.

Validaciones:

- Tipo de habitación.
- Número de personas.
- Número de noches.
- Fecha de entrada.
- Disponibilidad.
- Capacidad.
- Presupuesto.
- Memoria aplicada si faltan datos.

---

## 19. Limitaciones que se deben mencionar

El sistema actual no es productivo.

Limitaciones:

- No procesa pagos reales.
- No tiene autenticación.
- No tiene integración con PMS real.
- La reserva es demo.
- La consultoría avanzada está pendiente.
- La disponibilidad no maneja calendario real por fechas.
- No hay Telegram ni WhatsApp.
- No hay RAG vectorial avanzado.

---

## 20. Cierre sugerido de la demo

Frase sugerida:

```text
Este proyecto demuestra cómo n8n puede orquestar IA local, PostgreSQL y lógica de negocio para construir un asistente hotelero académico capaz de responder preguntas, consultar datos, recordar preferencias y registrar reservas demo de forma controlada.
```