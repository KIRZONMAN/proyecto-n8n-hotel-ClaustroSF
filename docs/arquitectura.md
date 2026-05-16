# Arquitectura del sistema — Reception Agent ClaustroSF

## 1. Descripción general

Reception Agent ClaustroSF es un sistema de automatización construido en n8n que simula un asistente virtual para el **Hotel El Claustro de San Francisco**.

El sistema integra:

- Un workflow de automatización en n8n.
- Un modelo local de lenguaje ejecutado con Ollama.
- Una base de datos PostgreSQL.
- Un documento base del hotel leído desde GitHub RAW.
- Un dataset histórico de reservas hoteleras.
- Una tabla operacional simulada de disponibilidad de habitaciones.

La arquitectura combina tres enfoques:

```text
1. Consulta documental
2. Analítica histórica
3. Operación simulada de disponibilidad y reservas
```

---

## 2. Objetivo arquitectónico

El objetivo arquitectónico es separar las responsabilidades del sistema en módulos claros:

| Módulo | Responsabilidad |
|---|---|
| Entrada y normalización | Recibir la pregunta del usuario y limpiarla. |
| Clasificación | Determinar qué tipo de solicitud hizo el usuario. |
| Enrutamiento | Enviar la solicitud al módulo correcto. |
| Consulta documental | Responder usando documentación del hotel. |
| Analítica | Consultar métricas del dataset histórico. |
| Reservas | Extraer datos básicos para simular reservas. |
| Seguridad | Bloquear solicitudes sensibles o fuera de alcance. |
| Disponibilidad | Consultar habitaciones disponibles desde PostgreSQL. |
| Memoria | Mantener historial conversacional. |

---

## 3. Vista general del workflow

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
   │     → IF - ¿Faltan Datos?
   │          ├── true  → Code - Confirmar Reserva Simulada
   │          └── false → Code - Pedir Datos Faltantes

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

## 4. Componentes principales

## 4.1 n8n

n8n actúa como motor de orquestación.

Sus responsabilidades principales son:

- Recibir la entrada del usuario.
- Ejecutar nodos de transformación.
- Enrutar la solicitud según intención.
- Consultar APIs, archivos remotos o bases de datos.
- Invocar el AI Agent.
- Estructurar la salida final.

---

## 4.2 Edit Fields

Este nodo define la entrada inicial del workflow.

Campos principales:

| Campo | Descripción |
|---|---|
| `pregunta_usuario` | Pregunta o solicitud escrita por el usuario. |
| `sessionId` | Identificador de sesión conversacional. |
| `documento_url` | URL RAW del documento base del hotel. |
| `nombre_hotel` | Nombre oficial del hotel. |
| `tipo_documento` | Tipo de documento usado para la consulta documental. |

Ejemplo:

```json
{
  "pregunta_usuario": "¿Cuál es la política de cancelación?",
  "sessionId": "demo-claustrosf",
  "documento_url": "https://raw.githubusercontent.com/...",
  "nombre_hotel": "Hotel El Claustro de San Francisco",
  "tipo_documento": "politicas_hotel"
}
```

---

## 4.3 Code - Normalizar Pregunta

Este nodo limpia la pregunta del usuario.

Funciones principales:

- Conserva la pregunta original.
- Convierte el texto a minúsculas.
- Elimina tildes.
- Elimina signos innecesarios.
- Reduce espacios repetidos.
- Calcula longitud de la pregunta.
- Marca si la pregunta es válida.

Ejemplo:

```text
Entrada:
¿Cuál es la política de cancelación?

Salida normalizada:
cual es la politica de cancelacion
```

---

## 4.4 Code - Clasificar Intención

Este nodo determina el tipo de solicitud.

Tipos reconocidos:

```text
documental
analitica_dataset
reserva_simulada
fuera_alcance
disponibilidad_habitaciones
consultoria
memoria_usuario
```

El clasificador usa listas de palabras clave y puntajes de coincidencia para decidir la ruta.

También devuelve:

| Campo | Descripción |
|---|---|
| `tipo_solicitud` | Tipo de solicitud detectado. |
| `confianza_clasificacion` | Nivel de confianza: alta, media o baja. |
| `motivo_clasificacion` | Explicación breve de por qué se clasificó así. |
| `score_clasificacion` | Conteo de coincidencias por categoría. |

Ejemplo:

```json
{
  "tipo_solicitud": "analitica_dataset",
  "confianza_clasificacion": "alta",
  "motivo_clasificacion": "La pregunta solicita análisis o métricas del dataset hotelero."
}
```

---

## 4.5 Switch - Tipo de solicitud

El nodo Switch enruta el flujo según el campo:

```text
tipo_solicitud
```

Reglas configuradas:

| Output | Valor esperado | Módulo conectado |
|---:|---|---|
| 0 | `documental` | Consulta documental |
| 1 | `analitica_dataset` | Analítica del dataset |
| 2 | `reserva_simulada` | Reserva simulada |
| 3 | `fuera_alcance` | Respuesta segura |
| 4 | `disponibilidad_habitaciones` | Disponibilidad en PostgreSQL |
| 5 | `consultoria` | Respuesta segura temporal |
| 6 | `memoria_usuario` | Respuesta segura temporal |

---

# 5. Módulo documental

## 5.1 Objetivo

Responder preguntas sobre políticas, servicios, horarios, habitaciones, normas y condiciones del hotel usando documentación oficial del proyecto.

## 5.2 Flujo

```text
Switch Output 0
→ HTTP Request
→ AI Agent
→ Code - Formatear Salida Documental
```

## 5.3 HTTP Request

El nodo `HTTP Request` lee el documento base desde GitHub RAW.

GitHub RAW entrega el contenido plano del archivo, lo que permite que n8n lo use como texto de entrada para el AI Agent.

Ejemplo de archivo remoto:

```text
Documento_Base_Hotel.md
```

## 5.4 AI Agent

El AI Agent recibe:

- Pregunta del usuario.
- Documento base del hotel.
- Instrucciones del sistema.
- Memoria conversacional.

El modelo usado es:

```text
llama3:latest
```

por medio de:

```text
Ollama Chat Model
```

## 5.5 Postgres Chat Memory

La memoria conversacional se guarda en PostgreSQL mediante:

```text
Postgres Chat Memory
```

Esto permite que el agente conserve historial de conversación asociado a una sesión.

## 5.6 Formateo documental

El nodo `Code - Formatear Salida Documental` limpia la respuesta del agente y entrega un JSON final con:

| Campo | Descripción |
|---|---|
| `tipo_solicitud` | Tipo de solicitud procesada. |
| `pregunta_usuario` | Pregunta original. |
| `pregunta_normalizada` | Pregunta limpia. |
| `nombre_hotel` | Nombre del hotel. |
| `modelo_usado` | Modelo de Ollama usado. |
| `fuente` | Documento usado como fuente. |
| `respuesta_final` | Respuesta limpia para el usuario. |
| `estado` | Estado del procesamiento. |
| `timestamp` | Fecha y hora de la respuesta. |

---

# 6. Módulo de analítica histórica

## 6.1 Objetivo

Responder preguntas sobre el dataset histórico de reservas hoteleras.

El dataset usado es:

```text
data/hotel_bookings.csv
```

Este dataset se carga en PostgreSQL en la tabla:

```text
hotel_bookings_raw
```

## 6.2 Flujo

```text
Switch Output 1
→ Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

## 6.3 Métricas consultadas

El nodo PostgreSQL consulta métricas como:

| Métrica | Descripción |
|---|---|
| `total_reservas` | Total de registros del dataset. |
| `tasa_cancelacion_porcentaje` | Porcentaje global de reservas canceladas. |
| `adr_promedio` | ADR promedio. |
| `lead_time_promedio` | Tiempo promedio de anticipación de reserva. |
| `reservas_city_hotel` | Total de reservas de City Hotel. |
| `reservas_resort_hotel` | Total de reservas de Resort Hotel. |
| `cancelacion_city_hotel` | Tasa de cancelación en City Hotel. |
| `cancelacion_resort_hotel` | Tasa de cancelación en Resort Hotel. |
| `mes_mas_reservas` | Mes con mayor cantidad de reservas. |
| `segmento_mas_frecuente` | Segmento de mercado más frecuente. |

## 6.4 Formateo analítico

El nodo `Code - Formatear Salida Analítica` interpreta la pregunta del usuario y devuelve una respuesta clara usando las métricas consultadas.

Ejemplos:

```text
¿Cuál es la tasa de cancelación del dataset?
¿Cuál es el ADR promedio?
¿Qué hotel tiene más reservas?
¿Cuál es el mes con más reservas?
```

---

# 7. Módulo de reserva simulada

## 7.1 Objetivo

Extraer datos básicos de una solicitud de reserva y determinar si la solicitud contiene suficiente información.

## 7.2 Flujo

```text
Switch Output 2
→ Code - Extraer Datos Reserva
→ IF - ¿Faltan Datos?
   ├── true  → Code - Confirmar Reserva Simulada
   └── false → Code - Pedir Datos Faltantes
```

## 7.3 Datos extraídos

El módulo intenta extraer:

| Campo | Descripción |
|---|---|
| `tipo_habitacion` | Tipo solicitado: sencilla, doble, triple, familiar o suite. |
| `numero_personas` | Número de huéspedes. |
| `numero_noches` | Duración de la estadía. |
| `fecha_entrada` | Fecha de entrada. |

Si falta algún dato, el sistema pide la información faltante.

Ejemplo:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches
```

Respuesta esperada:

```text
Para simular la reserva necesito que me indiques: fecha de entrada.
```

---

# 8. Módulo de respuesta segura

## 8.1 Objetivo

Evitar que el sistema responda solicitudes sensibles, inseguras o fuera de alcance.

## 8.2 Flujo

```text
Switch Output 3
→ Code - Respuesta Segura
```

También se usa temporalmente para:

```text
consultoria
memoria_usuario
```

hasta que esos módulos estén implementados.

## 8.3 Ejemplos de solicitudes bloqueadas

```text
Dame el token del sistema
Dame la contraseña del administrador
Borra la base de datos
Dame datos privados de un huésped
```

Respuesta esperada:

```text
No puedo proporcionar contraseñas, credenciales, datos privados, información interna sensible ni instrucciones que comprometan la seguridad del sistema o del hotel.
```

---

# 9. Módulo de disponibilidad operacional

## 9.1 Objetivo

Responder preguntas sobre disponibilidad actual de habitaciones usando PostgreSQL.

Este módulo representa una capa operacional simulada del hotel.

## 9.2 Justificación

El dataset `hotel_bookings.csv` contiene registros históricos de reservas, pero no contiene una tabla explícita de inventario actual de habitaciones.

Por eso se creó una tabla complementaria:

```text
habitaciones_demo
```

Esta tabla representa la disponibilidad operativa actual del hotel.

## 9.3 Flujo

```text
Switch Output 4
→ Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

## 9.4 Tabla habitaciones_demo

La tabla se crea mediante:

```text
scripts/sql/01_habitaciones_demo.sql
```

Contiene 550 habitaciones simuladas.

Distribución:

| Tipo de habitación | Cantidad |
|---|---:|
| Sencilla | 120 |
| Doble | 210 |
| Triple | 90 |
| Familiar | 80 |
| Suite | 50 |
| **Total** | **550** |

Campos principales:

| Campo | Descripción |
|---|---|
| `id` | Identificador interno. |
| `codigo_habitacion` | Código único de habitación. |
| `tipo_habitacion` | Tipo: sencilla, doble, triple, familiar o suite. |
| `capacidad_adultos` | Capacidad de adultos. |
| `capacidad_ninos` | Capacidad de niños. |
| `capacidad_total` | Capacidad total. |
| `vista` | Tipo de vista. |
| `precio_noche_cop` | Precio simulado por noche en COP. |
| `estado` | Estado actual. |
| `descripcion` | Descripción de la habitación. |
| `updated_at` | Fecha de actualización. |

Estados posibles:

```text
disponible
ocupada
reservada
mantenimiento
```

## 9.5 Vista vw_disponibilidad_habitaciones

La vista:

```text
vw_disponibilidad_habitaciones
```

resume la tabla por tipo de habitación.

Campos devueltos:

| Campo | Descripción |
|---|---|
| `tipo_habitacion` | Tipo de habitación. |
| `total_habitaciones` | Total de habitaciones de ese tipo. |
| `disponibles` | Habitaciones disponibles. |
| `ocupadas` | Habitaciones ocupadas. |
| `reservadas` | Habitaciones reservadas. |
| `mantenimiento` | Habitaciones en mantenimiento. |
| `capacidad_maxima` | Capacidad máxima del tipo. |
| `precio_minimo_cop` | Precio mínimo simulado. |
| `precio_maximo_cop` | Precio máximo simulado. |

## 9.6 Consulta SQL del nodo

El nodo `Postgres - Disponibilidad Habitaciones` ejecuta una consulta sobre la vista:

```sql
SELECT
    tipo_habitacion,
    total_habitaciones,
    disponibles,
    ocupadas,
    reservadas,
    mantenimiento,
    capacidad_maxima,
    precio_minimo_cop,
    precio_maximo_cop
FROM vw_disponibilidad_habitaciones
ORDER BY
    CASE tipo_habitacion
        WHEN 'sencilla' THEN 1
        WHEN 'doble' THEN 2
        WHEN 'triple' THEN 3
        WHEN 'familiar' THEN 4
        WHEN 'suite' THEN 5
        ELSE 6
    END;
```

## 9.7 Formateo de disponibilidad

El nodo `Code - Formatear Salida Disponibilidad` detecta si el usuario pregunta por un tipo específico.

Tipos reconocidos:

```text
sencilla
doble
triple
familiar
suite
```

Ejemplos:

```text
¿Cuántas habitaciones dobles hay disponibles?
¿Hay suites disponibles?
```

Si no detecta un tipo específico, responde con resumen general:

```text
¿Qué habitaciones hay disponibles?
¿Cuántas habitaciones están ocupadas?
```

---

# 10. Base de datos PostgreSQL

Tablas y vistas principales:

| Nombre | Tipo | Uso |
|---|---|---|
| `n8n_chat_histories` | Tabla | Memoria conversacional de n8n. |
| `hotel_bookings_raw` | Tabla | Dataset histórico hotelero. |
| `habitaciones_demo` | Tabla | Inventario operacional simulado. |
| `vw_disponibilidad_habitaciones` | Vista | Resumen de disponibilidad por tipo. |

---

# 11. Separación entre dataset histórico y operación actual

El sistema diferencia claramente dos fuentes de datos:

## Dataset histórico

```text
hotel_bookings.csv
```

Uso:

```text
Analítica histórica.
```

Ejemplos:

```text
Tasa de cancelación.
ADR promedio.
Lead time promedio.
Mes con más reservas.
Reservas por tipo de hotel.
```

## Tabla operacional

```text
habitaciones_demo
```

Uso:

```text
Disponibilidad actual simulada.
```

Ejemplos:

```text
Habitaciones disponibles.
Habitaciones ocupadas.
Habitaciones reservadas.
Habitaciones en mantenimiento.
Capacidad por tipo de habitación.
Rango de precios simulados.
```

Esta separación permite que el proyecto sea más coherente: el dataset histórico explica el comportamiento de reservas, mientras que la tabla operacional permite simular el trabajo de recepción.

---

# 12. Patrones y decisiones arquitectónicas

## 12.1 Separación de responsabilidades

Cada nodo cumple una responsabilidad concreta:

```text
Normalizar
Clasificar
Enrutar
Consultar
Generar respuesta
Formatear salida
```

Esto facilita mantenimiento y crecimiento del workflow.

## 12.2 Arquitectura basada en módulos

Cada tipo de solicitud se procesa en un módulo independiente.

Esto permite agregar nuevas capacidades sin romper las existentes.

## 12.3 Orquestación por workflow

n8n actúa como orquestador central.

El sistema no es una aplicación monolítica tradicional, sino un flujo de automatización conectado por nodos.

## 12.4 Uso de base de datos relacional

PostgreSQL permite almacenar y consultar:

- Historial conversacional.
- Dataset histórico.
- Inventario operacional de habitaciones.

## 12.5 Uso de IA local

Ollama permite ejecutar el modelo localmente, evitando dependencia directa de APIs pagadas para la generación documental.

---

# 13. Limitaciones arquitectónicas actuales

- El módulo de reservas todavía no inserta registros reales en PostgreSQL.
- La disponibilidad no se cruza todavía con fechas específicas.
- La consultoría hotelera todavía no tiene módulo propio.
- La memoria personalizada todavía no guarda preferencias avanzadas.
- El documento base depende de disponibilidad del archivo RAW en GitHub.
- El dataset histórico no representa inventario físico de habitaciones.
- El modelo local puede tardar dependiendo del equipo donde se ejecute.

---

# 14. Próximas mejoras arquitectónicas

- Crear tabla `reservas_simuladas`.
- Conectar reservas con disponibilidad real.
- Validar disponibilidad por fechas.
- Crear módulo de consultoría hotelera.
- Guardar preferencias del usuario.
- Implementar pgvector para búsqueda semántica.
- Integrar Telegram como canal de conversación.
- Separar prompts de sistema directamente desde archivos externos.
- Optimizar prompts para reducir consumo de tokens locales y tiempo de inferencia.