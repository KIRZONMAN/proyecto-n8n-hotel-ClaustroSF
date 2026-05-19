# Arquitectura del sistema — Reception Agent ClaustroSF

## 1. Descripción general

Reception Agent ClaustroSF es un sistema de automatización construido con **n8n** que simula un asistente virtual de recepción para el **Hotel El Claustro de San Francisco**.

El sistema integra:

- n8n como motor de orquestación.
- Ollama como motor de IA local.
- PostgreSQL como base de datos operacional.
- GitHub RAW como fuente documental externa.
- Dataset hotelero histórico.
- Inventario demo de habitaciones.
- Tabla de reservas demo.
- Tabla de memoria personalizada por sesión.
- Reglas de clasificación, validación y seguridad.

La arquitectura actual permite:

```text
consulta documental
analítica de dataset
consulta de disponibilidad
memoria personalizada
reserva demo inteligente
validación de presupuesto
manejo de errores controlados
```

---

## 2. Objetivo arquitectónico

El objetivo de la arquitectura es separar responsabilidades en módulos claros y defendibles:

| Módulo | Responsabilidad |
|---|---|
| Entrada | Recibir pregunta, sesión y datos base. |
| Normalización | Limpiar texto y preparar datos. |
| Clasificación | Identificar intención del usuario. |
| Enrutamiento | Enviar la solicitud a la rama correcta. |
| Documental | Responder usando documento base del hotel. |
| Analítica | Consultar métricas del dataset. |
| Disponibilidad | Consultar inventario de habitaciones. |
| Memoria | Guardar y consultar preferencias del usuario. |
| Reserva | Validar, buscar, registrar o rechazar reservas. |
| Seguridad | Evitar respuestas sensibles o fuera de alcance. |

---

## 3. Estilo arquitectónico

El sistema usa una arquitectura de automatización basada en flujo.

Patrones aplicados:

| Patrón / estilo | Aplicación |
|---|---|
| Pipeline | La solicitud pasa por etapas consecutivas. |
| Content-Based Routing | El `Switch` enruta según `tipo_solicitud`. |
| Separation of Concerns | Cada nodo tiene una responsabilidad específica. |
| Rule-Based Classification | Clasificación inicial mediante reglas. |
| AI-Assisted Extraction | La IA extrae memoria en JSON. |
| Validation Layer | Código valida JSON antes de guardar. |
| Repository / Data Access | PostgreSQL centraliza persistencia y consultas. |
| Transaction Script | SQL registra reserva y actualiza habitación. |
| Fail-Safe Response | Errores se convierten en respuestas controladas. |

---

## 4. Flujo general

```text
Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

Desde el `Switch`, se activan las ramas:

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

## 5. Rama documental

### Objetivo

Responder preguntas sobre políticas, normas, servicios y condiciones del hotel usando documentación del proyecto.

### Flujo

```text
Switch documental
→ HTTP Request
→ AI Agent
   └── Ollama Chat Model
   └── Postgres Chat Memory
→ Code - Formatear Salida Documental
```

### Fuente documental

```text
documentos/Documento_Base_Hotel.md
```

Leído mediante GitHub RAW.

### Responsabilidad del agente

El agente debe:

- Responder en español.
- Usar solo el documento base.
- No inventar datos.
- No revelar información sensible.
- No mencionar detalles técnicos innecesarios al usuario final.

---

## 6. Rama de analítica

### Objetivo

Responder preguntas sobre métricas históricas del dataset hotelero.

### Flujo

```text
Switch analitica_dataset
→ Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

### Tabla principal

```text
hotel_bookings_raw
```

### Métricas disponibles

- Total de reservas.
- Tasa de cancelación.
- ADR promedio.
- Lead time promedio.
- Reservas por tipo de hotel.
- Mes con más reservas.
- Segmento más frecuente.

---

## 7. Rama de disponibilidad

### Objetivo

Consultar el inventario operacional demo de habitaciones.

### Flujo

```text
Switch disponibilidad_habitaciones
→ Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

### Tabla principal

```text
habitaciones_demo
```

### Estados

```text
disponible
ocupada
reservada
mantenimiento
```

### Tipos

```text
sencilla
doble
triple
familiar
suite
```

---

## 8. Rama de memoria personalizada

### Objetivo

Guardar datos útiles del usuario para personalizar interacciones futuras.

### Flujo

```text
Switch memoria_usuario
→ AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
   ├── false → Code - Memoria No Guardada
   └── true
       → Postgres - Guardar Memoria Usuario
       → Code - Confirmar Memoria Guardada
```

### Tabla principal

```text
memoria_usuario_demo
```

### Campos principales

| Campo | Descripción |
|---|---|
| `session_id` | Identificador de sesión. |
| `nombre_usuario` | Nombre declarado por el usuario. |
| `numero_adultos` | Adultos recordados. |
| `numero_ninos` | Niños recordados. |
| `tipo_habitacion_preferida` | Tipo preferido. |
| `vista_preferida` | Vista preferida. |
| `presupuesto_max_cop` | Presupuesto máximo por noche. |
| `preferencias_texto` | Preferencias generales acumuladas. |
| `ultima_pregunta` | Última frase usada para memoria. |

### Enfoque híbrido

La memoria se implementa con el siguiente enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

La IA no ejecuta SQL, no cambia habitaciones y no registra reservas. Solo transforma lenguaje natural en JSON.

---

## 9. Rama de reserva inteligente

### Objetivo

Permitir reservas demo usando datos de la pregunta actual, memoria personalizada y validaciones de base de datos.

### Flujo completo

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

## 10. Aplicación de memoria en reservas

El nodo:

```text
Code - Aplicar Memoria a Reserva
```

usa memoria para completar datos faltantes.

Puede completar:

```text
tipo_habitacion
numero_personas
vista_preferida
presupuesto_max_cop
```

Ejemplo:

Memoria guardada:

```text
numero_adultos = 2
numero_ninos = 3
tipo_habitacion_preferida = familiar
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

Pregunta:

```text
Quiero reservar para mañana por 2 noches
```

Resultado:

```text
tipo_habitacion = familiar
numero_personas = 5
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

---

## 11. Regla de prioridad entre pregunta y memoria

La memoria nunca debe pisar datos explícitos del usuario.

Prioridad:

```text
1. Pregunta actual
2. Memoria guardada
3. Dato faltante
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
```

No se fuerza la habitación familiar.

---

## 12. Habitación exacta solicitada

Si el usuario pide una habitación por código:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

El sistema debe:

```text
1. Detectar código D-007.
2. Inferir que D-007 es tipo doble.
3. No aplicar tipo de habitación desde memoria.
4. Consultar exactamente D-007.
5. Registrar solo si D-007 está disponible.
6. Rechazar si D-007 está reservada, ocupada o no existe.
```

---

## 13. Validación de presupuesto

Después de encontrar disponibilidad, el sistema verifica:

```text
precio_noche_cop <= presupuesto_max_cop
```

Si se cumple:

```text
continúa a registrar reserva
```

Si no se cumple:

```text
Code - Fuera de Presupuesto
```

Esto evita registrar automáticamente reservas que excedan el presupuesto del usuario.

---

## 14. Persistencia de reservas

La reserva se registra en:

```text
reservas_demo
```

Y la habitación se actualiza en:

```text
habitaciones_demo
```

Operación esperada:

```text
habitaciones_demo.estado: disponible → reservada
reservas_demo.estado_reserva: confirmada_demo
```

---

## 15. Manejo de errores controlados

| Situación | Nodo encargado |
|---|---|
| Faltan datos | `Code - Pedir Datos Faltantes` |
| No hay disponibilidad | `Code - Sin Disponibilidad` |
| Habitación no existe | `Code - Sin Disponibilidad` |
| Habitación no disponible | `Code - Sin Disponibilidad` |
| Capacidad insuficiente | `Code - Sin Disponibilidad` |
| Fuera de presupuesto | `Code - Fuera de Presupuesto` |
| Memoria inválida | `Code - Memoria No Guardada` |
| Solicitud insegura | `Code - Respuesta Segura` |

---

## 16. Tablas principales

### `hotel_bookings_raw`

Dataset histórico para analítica.

### `habitaciones_demo`

Inventario operacional demo.

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

### `reservas_demo`

Reservas demo registradas.

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

### `memoria_usuario_demo`

Memoria personalizada.

Campos relevantes:

```text
session_id
nombre_usuario
numero_adultos
numero_ninos
tipo_habitacion_preferida
vista_preferida
presupuesto_max_cop
preferencias_texto
```

---

## 17. Decisiones arquitectónicas importantes

### Uso de n8n

Permite construir un prototipo funcional con integración visual entre IA, código y base de datos.

### Uso de PostgreSQL

Centraliza datos operacionales, reservas, memoria y dataset.

### Uso de Ollama

Permite trabajar con IA local sin depender de tokens pagos externos.

### Uso de IA solo en puntos específicos

La IA se usa para interpretar lenguaje natural, pero las decisiones críticas se validan con código y SQL.

### Separación de responsabilidades

El sistema evita que un solo nodo haga todo. Cada bloque tiene un papel claro.

---

## 18. Limitaciones actuales

- No existe autenticación real de usuarios.
- La memoria funciona por `session_id`.
- La disponibilidad no maneja calendario por fecha.
- La reserva es demo.
- No hay pagos.
- No hay confirmación humana final para reservas fuera de presupuesto.
- La fecha `mañana` puede manejarse como texto.
- No existe integración con Telegram o WhatsApp.
- No se usa pgvector todavía.

---

## 19. Resumen arquitectónico

El sistema funciona como una arquitectura modular de automatización:

```text
Entrada
→ Normalización
→ Clasificación
→ Enrutamiento
→ Módulos especializados
→ Validaciones
→ Respuesta final
```

La versión actual ya integra:

```text
IA local
PostgreSQL
GitHub RAW
Dataset hotelero
Inventario de habitaciones
Reservas demo
Memoria personalizada
Validación de presupuesto
Respuestas controladas
```

Esto lo convierte en un prototipo académico sólido para demostrar automatización hotelera con IA, datos y arquitectura modular en n8n.