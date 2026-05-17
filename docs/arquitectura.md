# Arquitectura del sistema — Reception Agent ClaustroSF

## 1. Descripción general

Reception Agent ClaustroSF es un sistema de automatización construido en **n8n** que simula un asistente virtual para el **Hotel El Claustro de San Francisco**.

El sistema integra:

- Un workflow de automatización en n8n.
- Un modelo local de lenguaje ejecutado con Ollama.
- Una base de datos PostgreSQL.
- Un documento base del hotel leído desde GitHub RAW.
- Un dataset histórico de reservas hoteleras.
- Una tabla operacional simulada de disponibilidad de habitaciones.
- Una tabla de reservas demo registradas por el workflow.
- Reglas de seguridad y clasificación separadas en archivos de prompts.

La arquitectura combina cuatro enfoques:

```text
1. Consulta documental asistida por IA
2. Analítica histórica sobre dataset
3. Consulta operacional de disponibilidad
4. Reserva demo con validación y persistencia en PostgreSQL
```

---

## 2. Objetivo arquitectónico

El objetivo arquitectónico es separar las responsabilidades del sistema en módulos claros y fáciles de explicar.

| Módulo | Responsabilidad |
|---|---|
| Entrada | Recibir la pregunta del usuario y datos base del hotel. |
| Normalización | Limpiar la pregunta y preparar texto para clasificación. |
| Clasificación | Determinar qué tipo de solicitud hizo el usuario. |
| Enrutamiento | Enviar la solicitud al módulo correcto mediante Switch. |
| Consulta documental | Responder usando documentación oficial del hotel. |
| Analítica | Consultar métricas del dataset histórico. |
| Disponibilidad | Consultar estado operacional de habitaciones. |
| Reserva | Extraer, validar, buscar, registrar y confirmar reservas demo. |
| Seguridad | Bloquear solicitudes sensibles o fuera de alcance. |
| Memoria | Mantener historial conversacional para el AI Agent. |

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

## 4. Estilo arquitectónico aplicado

El proyecto no usa una arquitectura monolítica tradicional con backend propio, sino una arquitectura de automatización por flujo.

Aun así, se pueden identificar varios patrones y estilos arquitectónicos:

| Patrón / estilo | Aplicación en el proyecto |
|---|---|
| Pipeline | La solicitud avanza por etapas: entrada, normalización, clasificación, enrutamiento y respuesta. |
| Router / Content-Based Routing | El nodo Switch decide la ruta según `tipo_solicitud`. |
| Separation of Concerns | Cada nodo tiene una responsabilidad específica. |
| Rule-Based Classification | La intención se clasifica mediante reglas y puntajes. |
| Document-Grounded QA | El módulo documental responde usando un documento base como fuente. |
| Repository / Data Access | PostgreSQL centraliza consultas de dataset, habitaciones y reservas. |
| Transaction Script | La reserva demo ejecuta una operación SQL que actualiza habitación e inserta reserva. |
| Fail-Safe Response | Solicitudes inseguras o no disponibles terminan en respuestas controladas. |

---

## 5. Componentes principales

## 5.1 n8n

n8n actúa como motor de orquestación.

Sus responsabilidades principales son:

- Recibir la entrada del usuario.
- Ejecutar nodos de transformación.
- Enrutar solicitudes según intención.
- Consultar archivos remotos mediante HTTP.
- Consultar PostgreSQL.
- Invocar el AI Agent.
- Estructurar la salida final.

---

## 5.2 Edit Fields

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
  "documento_url": "https://raw.githubusercontent.com/KIRZONMAN/proyecto-n8n-hotel-ClaustroSF/rtx/workflow/documentos/Documento_Base_Hotel.md",
  "nombre_hotel": "Hotel El Claustro de San Francisco",
  "tipo_documento": "politicas_hotel"
}
```

---

## 5.3 Code - Normalizar Pregunta

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

Campos generados:

| Campo | Descripción |
|---|---|
| `pregunta_original` | Texto original del usuario. |
| `pregunta_normalizada` | Texto limpio usado para clasificación. |
| `pregunta_valida` | Indica si la pregunta se puede procesar. |
| `longitud_pregunta` | Longitud del texto original o normalizado. |

---

## 5.4 Code - Clasificar Intención

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

El clasificador usa listas de palabras clave, reglas y puntajes de coincidencia para decidir la ruta.

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
  "tipo_solicitud": "reserva_simulada",
  "confianza_clasificacion": "alta",
  "motivo_clasificacion": "La pregunta expresa una intención de reserva."
}
```

---

## 5.5 Switch - Tipo de solicitud

El nodo Switch enruta el flujo según el campo:

```text
tipo_solicitud
```

Reglas configuradas:

| Output | Valor esperado | Módulo conectado |
|---:|---|---|
| 0 | `documental` | Consulta documental |
| 1 | `analitica_dataset` | Analítica del dataset |
| 2 | `reserva_simulada` | Reserva demo |
| 3 | `fuera_alcance` | Respuesta segura |
| 4 | `disponibilidad_habitaciones` | Disponibilidad en PostgreSQL |
| 5 | `consultoria` | Respuesta segura temporal |
| 6 | `memoria_usuario` | Respuesta segura temporal |

---

# 6. Módulo documental

## 6.1 Objetivo

Responder preguntas sobre políticas, servicios, horarios, habitaciones, normas y condiciones del hotel usando documentación oficial del proyecto.

## 6.2 Flujo

```text
Switch Output 0
→ HTTP Request
→ AI Agent
→ Code - Formatear Salida Documental
```

## 6.3 HTTP Request

El nodo `HTTP Request` lee el documento base desde GitHub RAW.

GitHub RAW entrega el contenido plano del archivo, lo que permite que n8n lo use como texto de entrada para el AI Agent.

Archivo usado:

```text
documentos/Documento_Base_Hotel.md
```

## 6.4 AI Agent

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

## 6.5 Memoria conversacional

El AI Agent usa:

```text
Postgres Chat Memory
```

Esto permite almacenar contexto conversacional asociado a un `sessionId`.

En la versión actual, la memoria se usa principalmente para el módulo documental. La memoria personalizada avanzada todavía queda como mejora futura.

## 6.6 Salida documental

El nodo `Code - Formatear Salida Documental` estructura la respuesta final con campos como:

| Campo | Descripción |
|---|---|
| `tipo_solicitud` | Tipo de solicitud procesada. |
| `pregunta_usuario` | Pregunta original. |
| `pregunta_normalizada` | Pregunta limpia. |
| `nombre_hotel` | Nombre del hotel. |
| `modelo_usado` | Modelo local usado. |
| `fuente` | Documento consultado. |
| `respuesta_final` | Respuesta final al usuario. |
| `estado` | Estado del proceso. |
| `timestamp` | Fecha/hora de generación. |

---

# 7. Módulo de analítica del dataset

## 7.1 Objetivo

Responder preguntas sobre métricas históricas del dataset hotelero.

## 7.2 Flujo

```text
Switch Output 1
→ Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

## 7.3 Fuente de datos

El dataset usado es:

```text
data/hotel_bookings.csv
```

En PostgreSQL se trabaja mediante la tabla:

```text
hotel_bookings_raw
```

## 7.4 Métricas consultadas

El nodo `Postgres - Métricas Dataset` puede entregar:

- Total de reservas.
- Tasa global de cancelación.
- ADR promedio.
- Lead time promedio.
- Reservas de City Hotel.
- Reservas de Resort Hotel.
- Tasa de cancelación de City Hotel.
- Tasa de cancelación de Resort Hotel.
- Mes con más reservas.
- Segmento de mercado más frecuente.

## 7.5 Ejemplos de preguntas

```text
¿Cuál es la tasa de cancelación del dataset?
¿Cuál es el ADR promedio?
¿Qué hotel tiene más reservas, City Hotel o Resort Hotel?
¿Cuál es el mes con más reservas?
```

---

# 8. Módulo de disponibilidad de habitaciones

## 8.1 Objetivo

Consultar el inventario operacional demo del hotel.

Este módulo responde preguntas sobre habitaciones disponibles, ocupadas, reservadas o en mantenimiento.

## 8.2 Flujo

```text
Switch Output 4
→ Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

## 8.3 Tabla usada

```text
habitaciones_demo
```

Esta tabla representa el inventario demo del hotel.

Cantidad aproximada:

```text
550 habitaciones
```

Tipos de habitación:

```text
sencilla
doble
triple
familiar
suite
```

Estados posibles:

```text
disponible
ocupada
reservada
mantenimiento
```

## 8.4 Campos principales

| Campo | Descripción |
|---|---|
| `codigo_habitacion` | Código único de la habitación. |
| `tipo_habitacion` | Tipo de habitación. |
| `estado` | Estado actual de la habitación. |
| `capacidad_total` | Capacidad máxima. |
| `vista` | Vista de la habitación. |
| `precio_noche_cop` | Precio por noche. |
| `descripcion` | Descripción general. |

## 8.5 Salida del módulo

El módulo devuelve:

- Total de habitaciones.
- Total disponibles.
- Total ocupadas.
- Total reservadas.
- Total en mantenimiento.
- Tipo consultado.
- Detalle de disponibilidad por tipo de habitación.
- Respuesta final en lenguaje natural.

---

# 9. Módulo de reserva demo

## 9.1 Objetivo

Permitir que el usuario haga una reserva demo, validando disponibilidad en PostgreSQL y registrando la operación en una tabla de reservas.

Este módulo es una simulación académica, pero se comporta como una versión inicial de un módulo real de recepción.

---

## 9.2 Flujo completo de reserva

```text
Switch Output 2
→ Code - Extraer Datos Reserva
→ IF - ¿Reserva Completa?
   ├── false
   │     → Code - Pedir Datos Faltantes
   └── true
         → Code - Validar Reserva Completa
         → Code - Preparar Consulta Reserva
         → Postgres - Buscar Habitación Disponible
         → IF - ¿Hay disponibilidad?
              ├── true
              │     → Code - Preparar Registro Reserva
              │     → Postgres - Registrar Reserva Demo
              │     → Code - Confirmar Reserva Registrada
              └── false
                    → Code - Sin Disponibilidad
```

---

## 9.3 Code - Extraer Datos Reserva

Este nodo extrae datos desde el texto del usuario.

Datos extraídos:

| Campo | Descripción |
|---|---|
| `tipo_habitacion` | Tipo solicitado por el usuario. |
| `tipo_habitacion_db` | Tipo normalizado para PostgreSQL. |
| `codigo_habitacion_solicitado` | Código manual solicitado, si existe. |
| `tipo_habitacion_inferida_codigo` | Tipo inferido a partir del código. |
| `numero_noches` | Número de noches. |
| `numero_personas` | Número de personas. |
| `fecha_entrada` | Fecha o referencia textual de entrada. |
| `datos_faltantes` | Lista de datos ausentes. |
| `reserva_completa` | Indica si la solicitud puede avanzar. |

Ejemplo:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

Salida esperada:

```json
{
  "tipo_habitacion": "habitación doble",
  "tipo_habitacion_db": "doble",
  "codigo_habitacion_solicitado": "D-007",
  "tipo_habitacion_inferida_codigo": "doble",
  "numero_noches": 2,
  "numero_personas": 2,
  "fecha_entrada": "mañana",
  "reserva_completa": true
}
```

---

## 9.4 IF - ¿Reserva Completa?

Este nodo valida si hacen falta datos.

Si faltan datos, la solicitud se dirige a:

```text
Code - Pedir Datos Faltantes
```

Ejemplo de solicitud incompleta:

```text
Quiero reservar una habitación doble para 2 noches
```

Respuesta esperada:

```text
Para simular la reserva necesito que me indiques: número de personas y fecha de entrada.
```

---

## 9.5 Code - Validar Reserva Completa

Este nodo confirma que los datos principales estén presentes y en formato usable antes de consultar PostgreSQL.

Validaciones principales:

- Tipo de habitación.
- Número de personas.
- Número de noches.
- Fecha de entrada.
- Código de habitación, si el usuario lo indicó.

---

## 9.6 Code - Preparar Consulta Reserva

Este nodo prepara los campos seguros para consulta SQL.

Genera campos como:

| Campo | Descripción |
|---|---|
| `tipo_habitacion_db_sql` | Tipo de habitación escapado para SQL. |
| `codigo_habitacion_solicitado_sql` | Código solicitado escapado para SQL. |
| `numero_personas` | Número convertido. |
| `numero_noches` | Número convertido. |
| `fecha_entrada_sql` | Fecha escapada. |
| `pregunta_usuario_sql` | Pregunta escapada. |
| `sessionId_sql` | Sesión escapada. |

Esto reduce errores al construir consultas dinámicas en n8n.

---

## 9.7 Postgres - Buscar Habitación Disponible

Este nodo consulta la tabla:

```text
habitaciones_demo
```

Tiene dos comportamientos:

### Selección manual

Ocurre cuando el usuario indica un código de habitación.

Ejemplo:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

El sistema valida:

```text
1. Que D-007 exista.
2. Que D-007 esté disponible.
3. Que D-007 tenga capacidad suficiente.
```

### Selección automática

Ocurre cuando el usuario no indica código de habitación.

Ejemplo:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

El sistema busca una habitación que cumpla:

```text
tipo_habitacion = doble
estado = disponible
capacidad_total >= número de personas
```

---

## 9.8 IF - ¿Hay disponibilidad?

Este nodo revisa el campo:

```text
habitaciones_disponibles
```

Condición:

```text
Number($json.habitaciones_disponibles) > 0
```

Si hay disponibilidad, continúa al registro de reserva.

Si no hay disponibilidad, envía la solicitud a:

```text
Code - Sin Disponibilidad
```

---

## 9.9 Code - Preparar Registro Reserva

Este nodo prepara los datos finales para insertar la reserva.

Genera:

| Campo | Descripción |
|---|---|
| `codigo_reserva` | Código único de reserva demo. |
| `codigo_habitacion` | Habitación seleccionada. |
| `codigo_habitacion_sql` | Código escapado para SQL. |
| `tipo_habitacion` | Tipo final. |
| `numero_personas` | Cantidad de personas. |
| `numero_noches` | Cantidad de noches. |
| `precio_noche_cop` | Precio por noche. |
| `total_estimado_cop` | Precio total estimado. |
| `modo_seleccion` | `manual` o `automatica`. |

---

## 9.10 Postgres - Registrar Reserva Demo

Este nodo ejecuta la operación de persistencia.

La operación hace dos cosas:

```text
1. Actualiza la habitación seleccionada:
   disponible → reservada

2. Inserta la reserva en:
   reservas_demo
```

La operación solo se completa si la habitación todavía está disponible.

Esto evita registrar una reserva sobre una habitación que ya cambió de estado.

---

## 9.11 Code - Confirmar Reserva Registrada

Este nodo genera la respuesta final para el usuario.

Ejemplo de respuesta:

```text
Reserva demo registrada correctamente. Se respetó la habitación solicitada por el usuario. Código de reserva: RSV-20260517195127-6X6PW3. Se asignó la habitación D-007, tipo doble, con capacidad para 3 persona(s), vista al hotel. La fecha de entrada indicada es mañana. El precio por noche es $195.000 y el total estimado para 2 noche(s) es $390.000. Esta reserva pertenece a un entorno académico/demo.
```

---

## 9.12 Code - Sin Disponibilidad

Este nodo responde cuando la reserva no puede realizarse.

Casos contemplados:

| Caso | Respuesta |
|---|---|
| `codigo_no_existe` | Informa que la habitación no existe en el inventario demo. |
| `habitacion_no_disponible` | Informa que la habitación existe, pero no está disponible. |
| `capacidad_insuficiente` | Informa que la habitación no tiene capacidad suficiente. |
| `sin_disponibilidad` | Informa que no hay habitaciones disponibles del tipo solicitado. |

Ejemplo:

```text
No pude registrar la reserva porque la habitación D-006 no tiene capacidad suficiente para 5 persona(s). Puedes intentar con una habitación de mayor capacidad, como una familiar o suite, según disponibilidad.
```

---

# 10. Seguridad y control de alcance

El sistema tiene rutas de seguridad para solicitudes no permitidas.

Ejemplo:

```text
Dame el token del sistema
```

Resultado esperado:

```text
No puedo entregar tokens, credenciales, contraseñas ni información interna del sistema.
```

El sistema evita responder solicitudes relacionadas con:

- Tokens.
- Contraseñas.
- Credenciales.
- Cuentas bancarias.
- Información interna.
- Datos sensibles.
- Peticiones fuera del alcance del hotel.

---

# 11. Modelo de datos resumido

## 11.1 Tabla `hotel_bookings_raw`

Uso:

```text
Analítica histórica del dataset hotelero.
```

Contiene registros históricos de reservas y cancelaciones.

---

## 11.2 Tabla `habitaciones_demo`

Uso:

```text
Inventario operacional demo.
```

Campos relevantes:

```text
codigo_habitacion
tipo_habitacion
estado
capacidad_total
vista
precio_noche_cop
descripcion
```

---

## 11.3 Tabla `reservas_demo`

Uso:

```text
Registro de reservas creadas desde el workflow.
```

Campos relevantes:

```text
codigo_reserva
codigo_habitacion
tipo_habitacion
numero_personas
numero_noches
total_estimado_cop
estado_reserva
```

---

# 12. Decisiones arquitectónicas importantes

## 12.1 Uso de n8n

Se usa n8n porque permite construir rápidamente un prototipo funcional con nodos visuales, integración con bases de datos, llamadas HTTP y conexión con modelos de IA.

## 12.2 Uso de PostgreSQL

PostgreSQL se usa como base de datos principal porque permite:

- Guardar dataset histórico.
- Consultar métricas.
- Guardar habitaciones demo.
- Registrar reservas demo.
- Guardar memoria conversacional.
- Validar cambios de estado.

## 12.3 Uso de Ollama

Ollama permite ejecutar el modelo localmente, sin depender de tokens pagos de una API externa para las pruebas del proyecto.

## 12.4 Uso de GitHub RAW

GitHub RAW permite que el documento base del hotel sea consultado como texto plano por n8n.

Esto facilita actualizar la documentación del hotel sin pegar todo el contenido manualmente dentro del workflow.

## 12.5 Separación de prompts

Las reglas del sistema se almacenan en:

```text
prompts/system/
```

Esto permite explicar mejor la separación entre:

```text
lógica del workflow
reglas de clasificación
reglas de seguridad
prompts por módulo
```

---

# 13. Limitaciones actuales

- La reserva sigue siendo demo/académica.
- No existe un frontend para usuarios reales.
- No hay integración con pasarelas de pago.
- No hay autenticación de usuarios finales.
- La fecha `mañana` todavía puede manejarse como texto y no como fecha real.
- El módulo de consultoría aún no está implementado.
- La memoria personalizada todavía está pendiente.
- No se ha implementado pgvector.
- No hay integración con Telegram o WhatsApp.
- El inventario de habitaciones es simulado.

---

# 14. Mejoras futuras

- Implementar consultoría hotelera con recomendaciones por número de adultos, niños, presupuesto y preferencias.
- Implementar memoria personalizada por usuario.
- Agregar pgvector para búsqueda semántica.
- Convertir fechas relativas a fechas reales.
- Crear módulo de cancelación de reservas demo.
- Crear integración con Telegram.
- Crear frontend web simple.
- Añadir pruebas automatizadas.
- Añadir logs de auditoría.
- Separar la lógica SQL en scripts versionados.
- Mejorar manejo de disponibilidad por fechas reales y no solo por estado general de habitación.

---

# 15. Resumen arquitectónico final

Reception Agent ClaustroSF MKII funciona como una arquitectura modular de automatización:

```text
Entrada
→ Normalización
→ Clasificación
→ Enrutamiento
→ Módulos especializados
→ Respuesta estructurada
```

La versión actual ya integra:

```text
IA local
PostgreSQL
GitHub RAW
Dataset hotelero
Inventario operacional
Reserva demo persistida
Validaciones de seguridad
Validaciones de disponibilidad
```

Esto lo convierte en un MVP sólido y extensible para explicar automatización hotelera, analítica e integración de IA dentro de un flujo de n8n.