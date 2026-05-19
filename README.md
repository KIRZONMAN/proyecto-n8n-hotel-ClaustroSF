# Reception Agent ClaustroSF — Asistente hotelero con n8n, PostgreSQL y Ollama

Proyecto académico desarrollado en **n8n** que simula un asistente virtual de recepción para el **Hotel El Claustro de San Francisco**.

El sistema integra automatización, IA local, PostgreSQL, memoria personalizada, consulta documental, analítica de dataset, disponibilidad de habitaciones y reserva demo inteligente.

---

## Estado actual del proyecto

Versión actual:

```text
MKIII — Memoria personalizada real + reservas inteligentes con disponibilidad y presupuesto
```

Esta versión extiende el MVP anterior porque el asistente ahora puede:

- Responder consultas documentales del hotel.
- Clasificar la intención del usuario.
- Consultar métricas de un dataset hotelero en PostgreSQL.
- Consultar disponibilidad operacional de habitaciones.
- Registrar reservas demo en PostgreSQL.
- Cambiar el estado de una habitación de `disponible` a `reservada`.
- Recordar información del usuario mediante memoria personalizada.
- Usar la memoria para completar reservas incompletas.
- Respetar datos explícitos del usuario por encima de la memoria.
- Validar disponibilidad, capacidad y presupuesto antes de registrar una reserva.
- Rechazar reservas inválidas con respuestas claras.

---

## Objetivo del proyecto

Construir un asistente automatizado para un hotel ficticio que pueda apoyar tareas de recepción mediante:

- Consulta documental de políticas, normas, horarios y servicios del hotel.
- Clasificación automática de la intención del usuario.
- Consulta de métricas históricas desde un dataset hotelero.
- Consulta de disponibilidad operacional de habitaciones.
- Registro de reservas demo en base de datos.
- Memoria personalizada por sesión.
- Validación de solicitudes incompletas, inseguras o fuera de alcance.
- Uso de IA local con Ollama.
- Integración de reglas, código y base de datos dentro de un workflow de n8n.

---

## Tecnologías utilizadas

| Tecnología | Uso dentro del proyecto |
|---|---|
| n8n | Orquestación visual del workflow. |
| PostgreSQL | Almacenamiento de dataset, habitaciones, reservas y memoria. |
| Docker / Docker Compose | Levantamiento del entorno local. |
| Ollama | Ejecución local del modelo de lenguaje. |
| llama3:latest | Modelo local usado por los agentes de IA. |
| GitHub RAW | Lectura remota del documento base del hotel. |
| JavaScript | Lógica en nodos Code de n8n. |
| SQL | Consultas, validaciones y persistencia en PostgreSQL. |
| CSV | Dataset histórico `hotel_bookings.csv`. |
| Markdown | Documentación y archivos de reglas/prompts. |

---

## Estructura general del proyecto

```text
ProyectoGeneral/
│
├── control/
│   ├── avances_rtx.md
│   ├── checklist_entrega.md
│   └── README.md
│
├── data/
│   └── hotel_bookings.csv
│
├── docs/
│   ├── README.md
│   ├── arquitectura.md
│   ├── explicacion_demo.md
│   ├── memoria_usuario.md
│   ├── plan_trabajo.md
│   ├── pruebas_funcionales.md
│   └── riesgos_y_limitaciones.md
│
├── documentos/
│   └── Documento_Base_Hotel.md
│
├── evidencias/
│   ├── pendientes.txt
│   └── README.md
│
├── prompts/
│   ├── README.md
│   └── system/
│       ├── reglas_clasificacion.md
│       ├── reglas_seguridad.md
│       ├── system_consultoria.md
│       ├── system_documental.md
│       └── system_reservas.md
│
├── scripts/
│   └── sql/
│       ├── 01_habitaciones_demo.sql
│       ├── 02_reservas_demo.sql
│       ├── 03_reset_reservas_demo.sql
│       └── 04_memoria_usuario_demo.sql
│
├── workflows/
│   └── UltimateMKII_Agent_Documental_ClaustroSF.json
│
├── .env.example
├── .gitignore
├── docker-compose.yml
└── README.md
```

---

## Workflow principal

El workflow principal se encuentra en:

```text
workflows/UltimateMKII_Agent_Documental_ClaustroSF.json
```

Nombre recomendado dentro de n8n:

```text
UltimateMKII_Agent_Documental_ClaustroSF
```

Aunque el archivo conserva el nombre MKII, la versión funcional actual incorpora mejoras de memoria personalizada, reserva inteligente y validación por presupuesto.

---

## Flujo general del sistema

```text
Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

Desde el `Switch`, el sistema puede enviar la solicitud a varias ramas:

```text
documental
analitica_dataset
disponibilidad_habitaciones
reserva_simulada
memoria_usuario
consultoria
fuera_alcance
```

---

## Tipos de solicitud reconocidos

| Tipo de solicitud | Descripción |
|---|---|
| `documental` | Preguntas sobre políticas, servicios, horarios, normas o información general del hotel. |
| `analitica_dataset` | Preguntas sobre métricas históricas del dataset hotelero. |
| `disponibilidad_habitaciones` | Consultas sobre habitaciones disponibles, ocupadas, reservadas o en mantenimiento. |
| `reserva_simulada` | Solicitudes para reservar habitaciones en entorno demo. |
| `memoria_usuario` | Datos personales o preferencias que el asistente debe recordar. |
| `consultoria` | Recomendaciones hoteleras. Pendiente de ampliación futura. |
| `fuera_alcance` | Solicitudes sensibles, inseguras o fuera del objetivo del sistema. |

---

## Módulo documental

El módulo documental responde preguntas usando el documento base del hotel:

```text
documentos/Documento_Base_Hotel.md
```

Este documento se consume desde GitHub RAW mediante un nodo `HTTP Request`.

Ejemplo:

```text
¿Cuál es la política de cancelación?
```

Resultado esperado:

```text
Respuesta basada en el documento oficial del hotel.
```

---

## Módulo de analítica del dataset

El proyecto usa el dataset:

```text
data/hotel_bookings.csv
```

En PostgreSQL se consulta mediante la tabla:

```text
hotel_bookings_raw
```

Permite responder preguntas como:

```text
¿Cuál es la tasa de cancelación del dataset?
¿Cuál es el ADR promedio?
¿Qué hotel tiene más reservas, City Hotel o Resort Hotel?
¿Cuál es el mes con más reservas?
```

---

## Módulo de disponibilidad de habitaciones

La disponibilidad se consulta desde:

```text
habitaciones_demo
```

Esta tabla representa un inventario demo del hotel con habitaciones de tipo:

```text
sencilla
doble
triple
familiar
suite
```

Y estados como:

```text
disponible
ocupada
reservada
mantenimiento
```

Ejemplo:

```text
¿Hay habitaciones dobles disponibles?
```

---

## Módulo de memoria personalizada

La memoria personalizada permite guardar datos del usuario por `session_id`.

Tabla usada:

```text
memoria_usuario_demo
```

Datos que puede guardar:

- Nombre del usuario.
- Número de adultos.
- Número de niños.
- Tipo de habitación preferida.
- Vista preferida.
- Presupuesto máximo por noche.
- Preferencias generales.

Ejemplos:

```text
Me llamo Hector y prefiero habitaciones tranquilas.
Somos 2 adultos y 3 niños.
Mi presupuesto es de 300000 por noche y prefiero vista al patio colonial.
Prefiero una habitación familiar cómoda.
```

Ruta principal:

```text
Switch memoria_usuario
→ AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
→ Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

La IA solo interpreta el texto y devuelve JSON. La validación, persistencia y decisiones críticas se hacen con código y PostgreSQL.

---

## Módulo de reserva demo inteligente

La reserva demo permite registrar reservas simuladas en PostgreSQL.

Tabla usada:

```text
reservas_demo
```

Ruta principal:

```text
Switch reserva_simulada
→ Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario Reserva
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
   ├── false → Code - Pedir Datos Faltantes
   └── true
       → Code - Validar Reserva Completa
       → Code - Preparar Consulta Reserva
       → Postgres - Buscar Habitación Disponible
       → If - ¿Hay disponibilidad?
          ├── false → Code - Sin Disponibilidad
          └── true
              → If - ¿Cumple presupuesto?
                 ├── false → Code - Fuera de Presupuesto
                 └── true
                     → Code - Preparar Registro Reserva
                     → Postgres - Registrar Reserva Demo
                     → Code - Confirmar Reserva Registrada
```

---

## Reserva con memoria

Si el usuario ya guardó datos como:

```text
2 adultos
3 niños
habitación familiar
vista al patio colonial
presupuesto máximo 300000
```

Luego puede escribir:

```text
Quiero reservar para mañana por 2 noches
```

El sistema puede completar:

```text
tipo_habitacion = familiar
numero_personas = 5
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

---

## Regla de prioridad

La memoria solo completa datos faltantes.

Si el usuario da un dato explícito en la pregunta actual, ese dato tiene prioridad sobre la memoria.

Prioridad:

```text
1. Pregunta actual del usuario
2. Memoria guardada
3. null / pedir dato faltante
```

Ejemplo:

Si la memoria dice:

```text
tipo_habitacion_preferida = familiar
presupuesto_max_cop = 300000
```

pero el usuario escribe:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

el sistema usa:

```text
tipo_habitacion = doble
numero_personas = 2
```

No fuerza la memoria familiar.

---

## Validaciones de reserva implementadas

| Caso | Resultado |
|---|---|
| Datos faltantes | Pide los datos faltantes. |
| Habitación disponible y presupuesto válido | Registra reserva demo. |
| Habitación exacta no disponible | Responde sin disponibilidad. |
| Habitación inexistente | Informa que el código no existe. |
| Capacidad insuficiente | Rechaza la reserva. |
| Presupuesto insuficiente | No registra automáticamente y explica la diferencia. |
| Datos explícitos vs memoria | Ganan los datos explícitos del usuario. |

---

## Comandos útiles

Levantar contenedores:

```bash
docker compose up -d
```

Crear inventario demo de habitaciones:

```bash
cat scripts/sql/01_habitaciones_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

Crear tabla de reservas demo:

```bash
cat scripts/sql/02_reservas_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

Crear tabla de memoria:

```bash
cat scripts/sql/04_memoria_usuario_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

Resetear reservas demo:

```bash
cat scripts/sql/03_reset_reservas_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

Consultar memoria:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT session_id, nombre_usuario, numero_adultos, numero_ninos, tipo_habitacion_preferida, vista_preferida, presupuesto_max_cop, preferencias_texto FROM memoria_usuario_demo;"
```

Consultar últimas reservas:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT codigo_reserva, codigo_habitacion, tipo_habitacion, numero_personas, numero_noches, total_estimado_cop, estado_reserva FROM reservas_demo ORDER BY id DESC LIMIT 5;"
```

Consultar habitaciones específicas:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT codigo_habitacion, tipo_habitacion, estado, capacidad_total, precio_noche_cop FROM habitaciones_demo WHERE codigo_habitacion IN ('D-007','D-042','F-035') ORDER BY codigo_habitacion;"
```

---

## Pruebas recomendadas para demo

Memoria:

```text
Me llamo Hector y prefiero habitaciones tranquilas.
Somos 2 adultos y 3 niños.
Mi presupuesto es de 300000 por noche y prefiero vista al patio colonial.
Prefiero una habitación familiar cómoda.
```

Reserva usando memoria:

```text
Quiero reservar para mañana por 2 noches.
```

Reserva explícita:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana.
```

Fuera de presupuesto:

```text
Quiero reservar una habitación familiar para mañana por 2 noches con presupuesto de 300000.
```

Presupuesto válido:

```text
Quiero reservar una habitación familiar para mañana por 2 noches con presupuesto de 350000.
```

Habitación exacta no disponible:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana.
```

Disponibilidad:

```text
¿Hay habitaciones dobles disponibles?
```

Documental:

```text
¿Cuál es la política de cancelación?
```

Analítica:

```text
¿Cuál es la tasa de cancelación del dataset?
```

---

## Limitaciones actuales

- La reserva sigue siendo demo/académica.
- No existe frontend externo para usuarios reales.
- No hay pasarela de pago.
- No hay autenticación de usuarios finales.
- La fecha `mañana` todavía puede manejarse como texto.
- La memoria funciona por `session_id`, no por usuario autenticado.
- La disponibilidad se basa en estado general de habitación, no en calendario real por fechas.
- El módulo de consultoría avanzada aún está pendiente.
- No se ha implementado pgvector.
- No hay integración con Telegram o WhatsApp.

---

## Próximas mejoras sugeridas

- Optimizar prompts y llamadas a IA.
- Reducir tiempos de respuesta de Ollama.
- Implementar pgvector para RAG documental.
- Implementar consultoría hotelera avanzada.
- Integrar Telegram.
- Crear frontend web.
- Convertir fechas relativas a fechas reales.
- Implementar disponibilidad por fechas.
- Añadir cancelación de reservas demo.
- Añadir confirmación explícita para reservas fuera de presupuesto.
- Documentar evidencias finales y guion de presentación.

---

## Autor

Proyecto académico desarrollado por:

```text
KIRZON
```

Para actividades universitarias relacionadas con automatización, IA, analítica, arquitectura y modelado computacional.