# Workflows de n8n

Esta carpeta contiene las exportaciones JSON del workflow principal del proyecto **Reception Agent ClaustroSF**, asistente hotelero académico para el **Hotel El Claustro de San Francisco**.

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

Abreviatura usada en el proyecto:

```text
ClaustroSF
```

---

## Workflow principal actual

El workflow principal actual del proyecto es:

```text
UltimateMKII_Agent_Documental_ClaustroSF.json
```

Este archivo representa el flujo avanzado construido en n8n con:

- Clasificación de intención.
- Consulta documental con IA local.
- Optimización de contexto documental.
- Analítica de dataset hotelero en PostgreSQL.
- Consulta de disponibilidad de habitaciones.
- Memoria personalizada por sesión.
- Reserva demo inteligente.
- Validación de capacidad, disponibilidad y presupuesto.
- Respuestas seguras para casos fuera de alcance.
- Persistencia en PostgreSQL.

---

## Estado actual del workflow

La versión actual ya no corresponde al flujo antiguo:

```text
Manual Trigger → Edit Fields → Code Node → Ollama
```

Ese enfoque fue superado.

El flujo actual usa una arquitectura modular por zonas:

```text
Zona 1 — Entrada y clasificación
Zona 2 — Consulta documental con IA
Zona 3 — Analítica del dataset
Zona 4 — Reserva demo inteligente
Zona 5 — Respuesta segura / excepciones
Zona 6 — Disponibilidad simple
Zona 7 — Memoria personalizada
```

---

## Estructura general del workflow

### Zona 1 — Entrada y clasificación

Recibe la pregunta del usuario, normaliza el texto y clasifica la intención.

Ruta principal:

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

El nodo `Switch - Tipo de solicitud` distribuye la solicitud hacia una de las ramas disponibles.

---

### Zona 2 — Módulo de consulta documental con IA

Responde preguntas sobre políticas, normas, servicios y condiciones del hotel usando el documento base del hotel.

Ruta:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

El documento se obtiene desde GitHub RAW:

```text
documentos/Documento_Base_Hotel.md
```

El nodo `Code - Preparar Contexto Documental` reduce el documento completo y selecciona solo el contexto relevante para disminuir tokens y mejorar precisión.

La IA usada en esta zona debe responder únicamente con información contenida en el contexto documental proporcionado.

---

### Zona 3 — Módulo de analítica del dataset

Consulta métricas generales del dataset hotelero cargado en PostgreSQL.

Ruta:

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

Este módulo no pasa por IA. Usa consultas SQL y formateo mediante JavaScript.

---

### Zona 4 — Módulo de reserva demo inteligente

Procesa solicitudes de reserva, completa datos con memoria personalizada cuando sea posible y registra reservas demo en PostgreSQL.

Ruta general:

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
```

Si la reserva está incompleta:

```text
Code - Pedir Datos Faltantes
```

Si la reserva está completa:

```text
Code - Validar Reserva Completa
→ Code - Preparar Consulta Reserva
→ Postgres - Buscar Habitación Disponible
→ If - ¿Hay disponibilidad?
```

Si no hay disponibilidad:

```text
Code - Sin Disponibilidad
```

Si hay disponibilidad, se valida presupuesto:

```text
If - ¿Cumple presupuesto?
```

Si no cumple presupuesto:

```text
Code - Fuera de Presupuesto
```

Si cumple presupuesto:

```text
Code - Preparar Registro Reserva
→ Postgres - Registrar Reserva Demo
→ Code - Confirmar Reserva Registrada
```

Este módulo no depende de IA para registrar reservas. Usa reglas, código y PostgreSQL.

---

### Zona 5 — Respuesta segura / excepciones

Gestiona solicitudes fuera de alcance o módulos todavía no implementados completamente.

Ruta:

```text
Code - Respuesta Segura
```

Actualmente recibe casos como:

```text
fuera_alcance
consultoria
```

La consultoría hotelera avanzada se conserva como intención clasificada, pero por ahora responde como módulo pendiente.

---

### Zona 6 — Disponibilidad simple

Consulta disponibilidad general de habitaciones desde PostgreSQL.

Ruta:

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

Este módulo permite responder preguntas como:

```text
¿Hay habitaciones familiares disponibles?
```

No usa IA. Consulta directamente la tabla de habitaciones demo.

---

### Zona 7 — Memoria personalizada

Guarda información útil del usuario para futuras consultas o reservas.

Ruta:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
```

Si la memoria no es válida:

```text
Code - Memoria No Guardada
```

Si la memoria es válida:

```text
Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

La memoria sigue el enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

La IA solo extrae datos en JSON. No ejecuta SQL, no registra reservas y no modifica habitaciones.

---

## Salidas del Switch

El nodo `Switch - Tipo de solicitud` trabaja con las siguientes rutas:

| Output | Tipo de solicitud | Zona destino | Estado |
|---|---|---|---|
| 0 | `documental` | Zona 2 | Funcional |
| 1 | `analitica_dataset` | Zona 3 | Funcional |
| 2 | `reserva_simulada` | Zona 4 | Funcional |
| 3 | `fuera_alcance` | Zona 5 | Funcional |
| 4 | `disponibilidad_habitaciones` | Zona 6 | Funcional |
| 5 | `consultoria` | Zona 5 | Pendiente como módulo propio |
| 6 | `memoria_usuario` | Zona 7 | Funcional |

---

## Modelos y servicios usados

| Componente | Uso |
|---|---|
| n8n | Orquestación del workflow. |
| PostgreSQL | Dataset, habitaciones, reservas y memoria. |
| Ollama | Ejecución local del modelo de lenguaje. |
| `llama3:latest` | Modelo local usado por los agentes de IA. |
| GitHub RAW | Fuente remota del documento base del hotel. |
| JavaScript | Validación, clasificación, extracción y formateo. |
| SQL | Consultas y persistencia de datos. |

---

## Nodos desconectados o legacy

Existe un nodo antiguo llamado:

```text
Code - Extraer Memoria Usuario
```

Este nodo está desconectado y no forma parte del flujo funcional actual.

La memoria actual se gestiona mediante:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ PostgreSQL
```

No se recomienda volver a conectar el nodo legacy salvo que sea para pruebas aisladas o comparación histórica.

---

## Buenas prácticas al exportar

Antes de subir un workflow exportado a GitHub:

- Revisar que no tenga credenciales embebidas.
- Confirmar que no incluya tokens, contraseñas o datos privados.
- Mantener el nombre del archivo principal actualizado.
- Verificar que el JSON exportado corresponda al workflow realmente usado en n8n.
- Si se cambia el nombre del workflow, actualizar este archivo.

---

## Estado recomendado para entrega

El workflow actual puede presentarse como una versión funcional avanzada del asistente hotelero, con módulos separados, IA local controlada y persistencia en PostgreSQL.

Los módulos más fuertes para demostrar son:

```text
1. Consulta documental optimizada con IA.
2. Analítica del dataset.
3. Disponibilidad de habitaciones.
4. Memoria personalizada.
5. Reserva demo inteligente con validación.
6. Respuesta segura ante solicitudes fuera de alcance.
```