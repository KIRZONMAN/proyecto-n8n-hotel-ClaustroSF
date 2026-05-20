# Arquitectura del sistema

Proyecto:

```text
Reception Agent ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

---

## 1. Descripción general

Reception Agent ClaustroSF es un asistente hotelero académico construido con **n8n**, **PostgreSQL** y **Ollama**.

El sistema simula una recepción inteligente capaz de:

- Responder preguntas documentales sobre el hotel.
- Consultar métricas de un dataset hotelero.
- Consultar disponibilidad de habitaciones.
- Guardar memoria personalizada del usuario.
- Usar memoria para completar reservas.
- Registrar reservas demo.
- Validar capacidad, disponibilidad y presupuesto.
- Rechazar solicitudes fuera de alcance de forma segura.

La arquitectura actual combina automatización visual, código JavaScript, SQL e IA local.

---

## 2. Objetivo arquitectónico

El objetivo de la arquitectura es separar responsabilidades por módulos, evitando que una sola parte del workflow haga todo.

La estructura busca que:

```text
IA interprete lenguaje natural cuando sea útil.
Code valide, limpie y normalice datos.
PostgreSQL consulte y persista información.
Switch enrute cada solicitud hacia el módulo correcto.
```

El sistema evita que la IA tome decisiones críticas directamente. Las operaciones sensibles como guardar memoria, consultar disponibilidad o registrar reservas se hacen con código y base de datos.

---

## 3. Tecnologías principales

| Tecnología | Uso dentro del sistema |
|---|---|
| n8n | Orquestación visual del workflow. |
| PostgreSQL | Dataset, habitaciones, reservas y memoria personalizada. |
| Ollama | Ejecución local de modelos de lenguaje. |
| `llama3:latest` | Modelo local usado por los agentes IA. |
| JavaScript | Lógica en nodos Code. |
| SQL | Consultas y persistencia. |
| GitHub RAW | Lectura remota del documento base del hotel. |
| Markdown | Documentación y fuente documental del hotel. |

---

## 4. Arquitectura por zonas

El workflow está organizado en siete zonas:

```text
Zona 1 — Entrada y clasificación
Zona 2 — Consulta documental con IA
Zona 3 — Analítica del dataset
Zona 4 — Reserva demo inteligente
Zona 5 — Respuesta segura / excepciones
Zona 6 — Disponibilidad simple
Zona 7 — Memoria personalizada
```

Esta separación permite explicar el proyecto de manera clara durante una demostración o sustentación.

---

## 5. Zona 1 — Entrada y clasificación

### Objetivo

Recibir la pregunta del usuario, normalizarla, clasificar su intención y enviarla al módulo adecuado.

### Ruta

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

### Responsabilidades

- Recibir `pregunta_usuario`.
- Mantener `sessionId`.
- Normalizar tildes, signos y texto.
- Clasificar la intención.
- Generar `tipo_solicitud`.
- Generar `confianza_clasificacion`.
- Generar `motivo_clasificacion`.
- Generar `score_clasificacion`.
- Enrutar hacia la zona correcta.

### Tipos de solicitud

```text
documental
analitica_dataset
reserva_simulada
fuera_alcance
disponibilidad_habitaciones
consultoria
memoria_usuario
```

---

## 6. Switch de enrutamiento

El nodo principal de enrutamiento es:

```text
Switch - Tipo de solicitud
```

Salidas actuales:

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

## 7. Zona 2 — Consulta documental con IA

### Objetivo

Responder preguntas sobre políticas, servicios, normas, condiciones y detalles generales del hotel usando el documento base.

### Ruta

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

### Fuente documental

```text
documentos/Documento_Base_Hotel.md
```

El documento se consulta mediante GitHub RAW.

### Optimización documental

Antes, el agente podía recibir demasiado contexto documental.  
Ahora se agregó:

```text
Code - Preparar Contexto Documental
```

Este nodo selecciona secciones relevantes del documento según la pregunta del usuario.

Esto permite:

- Reducir tokens.
- Evitar enviar todo el documento al agente.
- Mejorar precisión.
- Disminuir respuestas fuera de contexto.
- Mantener el módulo documental más eficiente.

### Rol de la IA documental

El `AI Agent` documental debe:

- Responder en español.
- Usar únicamente el contexto documental proporcionado.
- No inventar políticas, precios, horarios ni servicios.
- No mencionar detalles internos del workflow.
- No ejecutar reservas.
- No usar datos de memoria personalizada.

---

## 8. Zona 3 — Analítica del dataset

### Objetivo

Consultar métricas del dataset hotelero almacenado en PostgreSQL.

### Ruta

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

### Características

Este módulo no usa IA.  
Trabaja con SQL y formateo en JavaScript.

Puede responder preguntas como:

```text
Muéstrame métricas del dataset.
¿Cuál es la tasa de cancelación?
¿Cuál es el ADR promedio?
¿Cuántas reservas hay?
```

### Métricas consideradas

- Total de reservas.
- Reservas canceladas.
- Tasa de cancelación.
- ADR promedio.
- Lead time promedio.
- Hotel con más reservas.
- Mes con más reservas.
- Segmento de mercado más frecuente.

---

## 9. Zona 4 — Reserva demo inteligente

### Objetivo

Procesar solicitudes de reserva en un entorno académico/demo.

### Ruta general

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
```

Si faltan datos:

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

Si hay disponibilidad:

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

---

## 10. Funciones del módulo de reserva

El módulo de reserva permite:

- Detectar tipo de habitación.
- Detectar código exacto de habitación.
- Detectar número de personas.
- Detectar número de noches.
- Detectar fecha de entrada básica.
- Consultar memoria personalizada.
- Completar datos faltantes con memoria.
- Validar datos mínimos.
- Consultar habitación disponible.
- Validar capacidad.
- Validar presupuesto.
- Registrar reserva demo.
- Actualizar estado de habitación.

---

## 11. Reglas de prioridad en reservas

La regla principal es:

```text
Pregunta actual > Memoria guardada > Dato faltante
```

Ejemplo:

Memoria:

```text
tipo_habitacion_preferida = familiar
```

Pregunta actual:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Resultado:

```text
tipo_habitacion = doble
numero_personas = 2
```

La memoria no debe pisar datos explícitos.

---

## 12. Habitación exacta solicitada

Si el usuario solicita una habitación específica:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

El sistema debe:

- Detectar `D-007`.
- Inferir el tipo si aplica.
- Consultar exactamente esa habitación.
- No reemplazarla por una alternativa automática.
- Rechazar si está ocupada, reservada, en mantenimiento o no existe.
- Rechazar si no tiene capacidad suficiente.

---

## 13. Validación de presupuesto

El sistema puede usar presupuesto desde:

- Pregunta actual.
- Memoria personalizada.

La prioridad es:

```text
presupuesto explícito en pregunta actual > presupuesto guardado en memoria
```

Si se encuentra una habitación disponible pero supera el presupuesto:

```text
Code - Fuera de Presupuesto
```

No se registra automáticamente la reserva.

---

## 14. Zona 5 — Respuesta segura / excepciones

### Objetivo

Responder de forma controlada a solicitudes que no deben pasar por IA o que pertenecen a módulos pendientes.

### Ruta

```text
Code - Respuesta Segura
```

Recibe actualmente:

```text
fuera_alcance
consultoria
```

### Casos de uso

- Preguntas fuera del dominio hotelero.
- Solicitudes inseguras.
- Solicitudes de credenciales o datos privados.
- Consultoría hotelera avanzada, mientras el módulo específico esté pendiente.

---

## 15. Zona 6 — Disponibilidad simple

### Objetivo

Consultar disponibilidad general de habitaciones desde PostgreSQL.

### Ruta

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

### Características

Este módulo:

- No usa IA.
- Consulta la tabla de habitaciones demo.
- Resume disponibilidad por tipo.
- Diferencia estados como disponible, ocupada, reservada o mantenimiento.

Ejemplo:

```text
¿Hay habitaciones familiares disponibles?
```

---

## 16. Zona 7 — Memoria personalizada

### Objetivo

Guardar información útil del usuario para futuras reservas o consultas.

### Ruta

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
```

Si no es válida:

```text
Code - Memoria No Guardada
```

Si es válida:

```text
Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

### Enfoque

```text
IA interpreta → Code valida → PostgreSQL guarda
```

La IA no guarda directamente.  
La IA no ejecuta SQL.  
La IA solo propone un JSON estructurado.

---

## 17. Datos de memoria

El sistema puede guardar:

```text
nombre_usuario
numero_adultos
numero_ninos
tipo_habitacion_preferida
vista_preferida
presupuesto_max_cop
preferencias_texto
```

Ejemplo:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Resultado deseado:

```text
nombre_usuario = Hector
preferencias_texto = habitaciones tranquilas
```

Si la IA interpreta erróneamente que "tranquilas" es una vista, el nodo de validación debe descartar ese campo.

---

## 18. Defensa contra errores de IA

El nodo:

```text
Code - Validar Memoria Usuario JSON
```

cumple una función crítica.

Valida:

- JSON devuelto por la IA.
- Campos permitidos.
- Tipos de datos.
- Números.
- Presupuesto.
- Tipo de habitación.
- Vista preferida.
- Campos sospechosos.

Ejemplo de campo descartado:

```json
{
  "campo": "vista_preferida",
  "valor_original": "tranquilas",
  "motivo": "La IA confundió una preferencia general con una vista de habitación."
}
```

---

## 19. Base de datos

PostgreSQL almacena:

```text
dataset hotelero
habitaciones demo
reservas demo
memoria de usuario
```

Tablas relevantes:

```text
hotel_bookings
habitaciones_demo
reservas_demo
memoria_usuario_demo
```

---

## 20. Uso de IA

La IA se usa principalmente en:

```text
Consulta documental
Extracción de memoria personalizada
```

No se usa IA para:

```text
Clasificar intención
Calcular métricas
Consultar disponibilidad simple
Registrar reservas
Actualizar habitaciones
Validar presupuesto
Ejecutar SQL
```

Esto reduce riesgos y mejora control del sistema.

---

## 21. Limitaciones arquitectónicas

El sistema todavía tiene algunas limitaciones:

- La consultoría hotelera avanzada no tiene módulo propio.
- La reserva es demo, no productiva.
- No hay pagos reales.
- No hay autenticación real.
- La memoria depende de `session_id`.
- La disponibilidad no maneja calendario real por fechas.
- No hay integración con Telegram o WhatsApp.
- No hay RAG vectorial avanzado.
- No hay frontend de usuario final.

---

## 22. Resumen arquitectónico

El sistema sigue esta idea general:

```text
Entrada
→ Normalización
→ Clasificación
→ Switch
→ Módulo especializado
→ Validación
→ PostgreSQL / IA / Code
→ Respuesta final
```

El proyecto actual puede presentarse como un asistente hotelero académico modular, con IA local controlada y operaciones de negocio simuladas mediante PostgreSQL.