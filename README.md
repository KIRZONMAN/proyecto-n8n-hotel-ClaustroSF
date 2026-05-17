# Reception Agent ClaustroSF — Asistente hotelero con n8n, PostgreSQL y Ollama

Proyecto académico basado en un workflow de **n8n** que simula un asistente virtual de recepción para el **Hotel El Claustro de San Francisco**.

El sistema permite responder consultas documentales sobre políticas del hotel, consultar métricas históricas de un dataset hotelero, consultar disponibilidad operacional de habitaciones y registrar reservas demo en PostgreSQL.

---

## Estado actual del proyecto

Versión actual:

```text
MKII — Reserva demo con disponibilidad realista en PostgreSQL
```

Esta versión mejora el MVP inicial porque ya no solo simula una reserva con texto, sino que:

- Consulta habitaciones disponibles desde PostgreSQL.
- Permite selección automática de habitación.
- Permite selección manual por código de habitación.
- Valida si la habitación existe.
- Valida si la habitación está disponible.
- Valida si la habitación tiene capacidad suficiente.
- Registra la reserva demo en PostgreSQL.
- Cambia el estado de la habitación de `disponible` a `reservada`.
- Rechaza reservas inválidas con mensajes seguros y claros.

---

## Objetivo del proyecto

Construir un asistente automatizado para un hotel ficticio que pueda apoyar tareas de recepción mediante:

- Consulta documental de políticas, normas, servicios y condiciones del hotel.
- Clasificación automática de la intención del usuario.
- Consulta de métricas históricas desde un dataset hotelero.
- Consulta de disponibilidad operacional de habitaciones.
- Registro de reservas demo en base de datos.
- Validación de solicitudes inseguras, incompletas o fuera de alcance.
- Uso de memoria conversacional en PostgreSQL.
- Integración con un modelo local mediante Ollama.

---

## Tecnologías utilizadas

| Tecnología | Uso dentro del proyecto |
|---|---|
| n8n | Orquestación del workflow. |
| PostgreSQL | Almacenamiento de dataset, habitaciones, reservas demo y memoria conversacional. |
| Docker / Docker Compose | Levantamiento del entorno local. |
| Ollama | Ejecución local del modelo de lenguaje. |
| llama3:latest | Modelo usado por el AI Agent. |
| GitHub RAW | Lectura remota del documento base del hotel. |
| JavaScript | Lógica de normalización, clasificación, extracción y formateo. |
| CSV | Dataset histórico `hotel_bookings.csv`. |
| Markdown | Documentación del proyecto y prompts del sistema. |

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
│       └── 03_reset_reservas_demo.sql
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

---

## Flujo general del workflow

```text
Manual Trigger
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud

   ├── documental
   │     → HTTP Request
   │     → AI Agent
   │          ├── Ollama Chat Model
   │          └── Postgres Chat Memory
   │     → Code - Formatear Salida Documental

   ├── analitica_dataset
   │     → Postgres - Métricas Dataset
   │     → Code - Formatear Salida Analítica

   ├── reserva_simulada
   │     → Code - Extraer Datos Reserva
   │     → IF - ¿Reserva Completa?
   │          ├── false → Code - Pedir Datos Faltantes
   │          └── true
   │                → Code - Validar Reserva Completa
   │                → Code - Preparar Consulta Reserva
   │                → Postgres - Buscar Habitación Disponible
   │                → IF - ¿Hay disponibilidad?
   │                     ├── true
   │                     │     → Code - Preparar Registro Reserva
   │                     │     → Postgres - Registrar Reserva Demo
   │                     │     → Code - Confirmar Reserva Registrada
   │                     └── false
   │                           → Code - Sin Disponibilidad

   ├── fuera_alcance
   │     → Code - Respuesta Segura

   ├── disponibilidad_habitaciones
   │     → Postgres - Disponibilidad Habitaciones
   │     → Code - Formatear Salida Disponibilidad

   ├── consultoria
   │     → Code - Respuesta Segura

   └── memoria_usuario
         → Code - Respuesta Segura
```

---

## Tipos de solicitud reconocidos

El nodo `Code - Clasificar Intención` permite clasificar las preguntas en los siguientes tipos:

| Tipo de solicitud | Descripción |
|---|---|
| `documental` | Preguntas sobre políticas, servicios, horarios, normas o información general del hotel. |
| `analitica_dataset` | Preguntas sobre métricas históricas del dataset hotelero. |
| `reserva_simulada` | Solicitudes para reservar habitaciones en el entorno demo. |
| `fuera_alcance` | Solicitudes sensibles, inseguras o no permitidas. |
| `disponibilidad_habitaciones` | Preguntas sobre habitaciones disponibles, ocupadas, reservadas o en mantenimiento. |
| `consultoria` | Solicitudes de recomendación hotelera. Actualmente queda como módulo pendiente. |
| `memoria_usuario` | Información personal o preferencias que podrían recordarse. Actualmente queda como módulo pendiente. |

---

## Módulo documental

El módulo documental responde preguntas usando el documento base del hotel almacenado en GitHub y leído mediante GitHub RAW.

Ejemplo:

```text
¿Cuál es la política de cancelación?
```

Flujo interno:

```text
HTTP Request
→ AI Agent
→ Code - Formatear Salida Documental
```

El agente tiene reglas para:

- Responder en español.
- Responder de forma clara, breve y amable.
- Usar únicamente la información contenida en el documento.
- No inventar datos.
- No entregar contraseñas, cuentas bancarias, teléfonos internos ni información sensible.
- No mencionar que está leyendo un Markdown o archivo técnico.

---

## GitHub RAW

El documento base del hotel se consume desde una URL de GitHub RAW.

GitHub RAW permite acceder directamente al contenido plano de un archivo del repositorio, sin cargar la interfaz visual de GitHub. Esto permite que n8n lea el documento como texto mediante un nodo `HTTP Request`.

En este proyecto se usa para cargar dinámicamente:

```text
documentos/Documento_Base_Hotel.md
```

Ventaja principal:

```text
Si el documento se actualiza en GitHub, el workflow puede leer la versión actualizada sin modificar manualmente el contenido dentro de n8n.
```

---

## Módulo de analítica del dataset

El proyecto usa el dataset:

```text
data/hotel_bookings.csv
```

Este dataset contiene registros históricos de reservas hoteleras.

En PostgreSQL se carga en la tabla:

```text
hotel_bookings_raw
```

El nodo:

```text
Postgres - Métricas Dataset
```

consulta métricas como:

- Total de reservas.
- Tasa global de cancelación.
- ADR promedio.
- Lead time promedio.
- Reservas de City Hotel.
- Reservas de Resort Hotel.
- Tasa de cancelación de City Hotel.
- Tasa de cancelación de Resort Hotel.
- Mes con más reservas.
- Segmento más frecuente.

Ejemplos de preguntas:

```text
¿Cuál es la tasa de cancelación del dataset?
¿Cuál es el ADR promedio?
¿Qué hotel tiene más reservas, City Hotel o Resort Hotel?
¿Cuál es el mes con más reservas?
```

---

## Módulo de disponibilidad de habitaciones

La disponibilidad se consulta desde la tabla operacional:

```text
habitaciones_demo
```

Esta tabla representa un inventario demo del hotel con aproximadamente:

```text
550 habitaciones
```

Cada habitación puede tener datos como:

- Código de habitación.
- Tipo de habitación.
- Estado.
- Capacidad total.
- Vista.
- Precio por noche.
- Descripción.

Estados usados:

```text
disponible
ocupada
reservada
mantenimiento
```

Tipos de habitación usados:

```text
sencilla
doble
triple
familiar
suite
```

Ejemplos de preguntas:

```text
¿Cuántas habitaciones dobles hay disponibles?
¿Hay suites disponibles?
¿Qué habitaciones hay disponibles?
```

---

## Módulo de reserva demo

La reserva demo es el módulo más completo de la versión MKII.

Permite dos formas de reserva:

### 1. Selección automática

El usuario no indica código de habitación específico.

Ejemplo:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

El sistema busca una habitación disponible que cumpla:

```text
tipo_habitacion = doble
estado = disponible
capacidad_total >= número de personas
```

Luego asigna una habitación disponible y registra la reserva.

---

### 2. Selección manual

El usuario indica el código de habitación.

Ejemplo:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

El sistema valida:

```text
1. Que D-007 exista.
2. Que D-007 esté disponible.
3. Que D-007 tenga capacidad suficiente.
4. Que el tipo de habitación sea coherente.
```

Si todo está correcto:

```text
1. Registra la reserva en reservas_demo.
2. Cambia D-007 de disponible a reservada.
3. Devuelve un código de reserva.
```

---

## Tablas principales en PostgreSQL

### `hotel_bookings_raw`

Tabla con el dataset histórico de reservas hoteleras.

Uso principal:

```text
Analítica del dataset.
```

---

### `habitaciones_demo`

Tabla operacional simulada de habitaciones.

Uso principal:

```text
Consultar disponibilidad y validar reservas.
```

Campos principales:

| Campo | Descripción |
|---|---|
| `codigo_habitacion` | Código único de la habitación. |
| `tipo_habitacion` | Tipo: sencilla, doble, triple, familiar o suite. |
| `estado` | Estado: disponible, ocupada, reservada o mantenimiento. |
| `capacidad_total` | Número máximo de personas. |
| `vista` | Vista asociada a la habitación. |
| `precio_noche_cop` | Precio por noche en pesos colombianos. |
| `descripcion` | Descripción breve de la habitación. |

---

### `reservas_demo`

Tabla donde se registran las reservas realizadas desde el workflow.

Uso principal:

```text
Guardar reservas demo confirmadas.
```

Campos principales:

| Campo | Descripción |
|---|---|
| `codigo_reserva` | Código generado para la reserva. |
| `codigo_habitacion` | Habitación asignada. |
| `tipo_habitacion` | Tipo de habitación reservada. |
| `numero_personas` | Cantidad de personas. |
| `numero_noches` | Cantidad de noches. |
| `total_estimado_cop` | Total estimado de la reserva. |
| `estado_reserva` | Estado de la reserva demo. |

---

## Validaciones implementadas en reserva

El workflow valida los siguientes casos:

| Caso | Resultado esperado |
|---|---|
| Faltan datos de reserva | Pide los datos faltantes. |
| Habitación disponible | Registra la reserva. |
| Habitación ya reservada u ocupada | Rechaza la reserva. |
| Habitación inexistente | Informa que el código no existe. |
| Capacidad insuficiente | Rechaza la reserva y sugiere una habitación de mayor capacidad. |
| Solicitud sensible | Responde mediante ruta segura. |

---

## Ejemplos de pruebas

### Consulta documental

```text
¿Cuál es la política de cancelación?
```

Resultado esperado:

```text
Respuesta basada en Documento_Base_Hotel.md.
```

---

### Analítica

```text
¿Cuál es la tasa de cancelación del dataset?
```

Resultado esperado:

```text
Tasa global aproximada de cancelación del dataset.
```

---

### Disponibilidad

```text
¿Cuántas habitaciones dobles hay disponibles?
```

Resultado esperado:

```text
Resumen de habitaciones disponibles, ocupadas, reservadas y en mantenimiento.
```

---

### Reserva automática

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Resultado esperado:

```text
El sistema asigna automáticamente una habitación doble disponible y registra la reserva demo.
```

---

### Reserva manual

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

Resultado esperado:

```text
El sistema respeta la habitación solicitada, valida disponibilidad y registra la reserva demo.
```

---

### Habitación inexistente

```text
Quiero reservar la habitación D-999 para 2 personas por 2 noches mañana
```

Resultado esperado:

```text
El sistema informa que la habitación no existe en el inventario demo.
```

---

### Capacidad insuficiente

```text
Quiero reservar la habitación D-006 para 5 personas por 2 noches mañana
```

Resultado esperado:

```text
El sistema informa que la habitación no tiene capacidad suficiente.
```

---

## Comandos útiles de PostgreSQL

Ver últimas reservas demo:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT codigo_reserva, codigo_habitacion, tipo_habitacion, numero_personas, numero_noches, total_estimado_cop, estado_reserva FROM reservas_demo ORDER BY id DESC LIMIT 5;"
```

Ver estado de habitaciones específicas:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT codigo_habitacion, tipo_habitacion, estado, capacidad_total FROM habitaciones_demo WHERE codigo_habitacion IN ('D-006','D-007','D-999') ORDER BY codigo_habitacion;"
```

Resetear reservas demo:

```bash
cat scripts/sql/03_reset_reservas_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

Verificar que no existan reservas demo:

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT COUNT(*) FROM reservas_demo;"
```

---

## Cómo ejecutar el proyecto

### 1. Levantar contenedores

```bash
docker compose up -d
```

### 2. Verificar PostgreSQL

```bash
docker compose exec postgres psql -U claustrosf_user -d claustrosf_db -c "SELECT version();"
```

### 3. Ejecutar scripts SQL necesarios

```bash
cat scripts/sql/01_habitaciones_demo.sql | docker compose exec -T postgres psql -U claustrosf_user -d claustrosf_db
```

### 4. Ejecutar Ollama

```bash
ollama run llama3
```

### 5. Importar workflow en n8n

Importar el archivo:

```text
workflows/UltimateMKII_Agent_Documental_ClaustroSF.json
```

### 6. Probar desde n8n

Abrir el workflow y ejecutar:

```text
Execute workflow
```

---

## Limitaciones actuales

- El módulo de consultoría hotelera todavía está pendiente.
- El módulo de memoria personalizada todavía está en estado inicial.
- La reserva es demo/académica, no representa una reserva real.
- La fecha de entrada se maneja como texto simple en algunos casos, por ejemplo `mañana`.
- No hay integración con Telegram, WhatsApp o frontend externo.
- No se usa todavía pgvector para búsqueda semántica avanzada.
- La disponibilidad es simulada mediante una tabla operacional creada para el proyecto.

---

## Próximas mejoras sugeridas

- Implementar módulo de consultoría hotelera.
- Mejorar memoria personalizada por usuario.
- Integrar pgvector para búsqueda semántica.
- Agregar frontend o integración con Telegram.
- Convertir fechas relativas como `mañana` a fechas reales.
- Añadir cancelación de reservas demo.
- Agregar filtros por presupuesto, vista, número de niños/adultos y preferencias.
- Añadir pruebas automatizadas sobre las rutas principales.
- Separar aún más prompts, reglas y lógica del workflow.

---

## Autor

Proyecto académico desarrollado por:

```text
KIRZON
```

Para actividades universitarias relacionadas con automatización, IA, analítica y modelado computacional.