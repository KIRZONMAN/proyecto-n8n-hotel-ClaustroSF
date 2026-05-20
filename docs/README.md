# Documentación del proyecto

Esta carpeta contiene la documentación técnica y funcional del proyecto **Reception Agent ClaustroSF**, asistente hotelero académico construido con n8n, PostgreSQL y Ollama.

Hotel del caso de estudio:

```text
Hotel El Claustro de San Francisco
```

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

Abreviatura:

```text
ClaustroSF
```

---

## Estado general documentado

La documentación debe reflejar el estado actual del workflow, que ya incluye:

- Clasificación de intención.
- Consulta documental con IA local.
- Optimización de contexto documental.
- Analítica del dataset en PostgreSQL.
- Consulta de disponibilidad de habitaciones.
- Memoria personalizada.
- Reserva demo inteligente.
- Validación de capacidad, disponibilidad y presupuesto.
- Respuestas seguras.
- Separación del workflow por zonas.

El proyecto ya no debe describirse como un flujo básico de un solo Code Node llamando a Ollama.

---

## Archivos principales

| Archivo | Propósito |
|---|---|
| `arquitectura.md` | Explica los componentes, módulos, flujo general y decisiones arquitectónicas del sistema. |
| `plan_trabajo.md` | Describe las fases del proyecto, su estado actual y el trabajo pendiente. |
| `pruebas_funcionales.md` | Define pruebas para clasificación, documental, analítica, disponibilidad, memoria, reserva y respuesta segura. |
| `explicacion_demo.md` | Guion y explicación para presentar el proyecto en clase. |
| `memoria_usuario.md` | Documenta el módulo de memoria personalizada y su enfoque `IA interpreta → Code valida → PostgreSQL guarda`. |
| `riesgos_y_limitaciones.md` | Describe riesgos, limitaciones actuales y mitigaciones. |

---

## Módulos que debe cubrir la documentación

### 1. Entrada y clasificación

Ruta:

```text
When clicking Execute workflow
→ Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

Responsabilidad:

```text
Recibir la pregunta, normalizarla, clasificarla y enviarla al módulo correcto.
```

---

### 2. Consulta documental con IA

Ruta:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

Responsabilidad:

```text
Responder preguntas sobre políticas, normas, servicios y condiciones del hotel usando el documento base.
```

---

### 3. Analítica del dataset

Ruta:

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

Responsabilidad:

```text
Consultar métricas generales del dataset hotelero cargado en PostgreSQL.
```

---

### 4. Reserva demo inteligente

Ruta resumida:

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ Validaciones
→ Postgres - Registrar Reserva Demo
→ Code - Confirmar Reserva Registrada
```

Responsabilidad:

```text
Procesar reservas demo, validar información, buscar habitaciones disponibles y registrar reservas simuladas.
```

---

### 5. Respuesta segura

Ruta:

```text
Code - Respuesta Segura
```

Responsabilidad:

```text
Responder de forma controlada ante solicitudes fuera de alcance, inseguras o asociadas a módulos pendientes.
```

---

### 6. Disponibilidad simple

Ruta:

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

Responsabilidad:

```text
Consultar disponibilidad general de habitaciones desde PostgreSQL.
```

---

### 7. Memoria personalizada

Ruta:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
→ PostgreSQL
```

Responsabilidad:

```text
Guardar preferencias y datos útiles del usuario por sesión.
```

---

## Modelo de IA actual

El modelo local usado por los agentes de IA es:

```text
llama3:latest
```

Se usa mediante Ollama.

La IA se utiliza principalmente en:

```text
Consulta documental
Extracción de memoria personalizada
```

No se usa IA para:

```text
Registrar reservas directamente
Ejecutar SQL
Modificar habitaciones directamente
Calcular métricas del dataset
Consultar disponibilidad simple
```

---

## Base de datos

PostgreSQL se usa para:

- Dataset hotelero.
- Habitaciones demo.
- Reservas demo.
- Memoria personalizada.

Tablas relevantes:

```text
hotel_bookings
habitaciones_demo
reservas_demo
memoria_usuario_demo
```

---

## Documentos externos relacionados

Además de esta carpeta, también son importantes:

```text
../README.md
../workflows/README.md
../control/checklist_entrega.md
../control/avances_rtx.md
../documentos/Documento_Base_Hotel.md
../documentos/Preguntas_Prueba_Hotel.md
../evidencias/README.md
```

---

## Reglas para mantener esta documentación

Al actualizar el proyecto, revisar que la documentación:

- No mencione el flujo antiguo como flujo principal.
- No diga que `AI Agent` es una mejora futura, porque ya está implementado.
- No diga que PostgreSQL es futuro, porque ya está implementado.
- No diga que memoria personalizada es futura, porque ya está implementada.
- No diga que reserva demo inteligente es futura, porque ya está implementada.
- No presente consultoría hotelera como completa, porque todavía está pendiente como módulo propio.
- No presente el sistema como producción real.
- No incluya credenciales, claves ni datos privados.

---

## Estado recomendado de lectura

Para entender el proyecto, leer en este orden:

```text
1. README.md del repositorio
2. docs/arquitectura.md
3. docs/plan_trabajo.md
4. docs/memoria_usuario.md
5. docs/pruebas_funcionales.md
6. docs/explicacion_demo.md
7. docs/riesgos_y_limitaciones.md
8. workflows/README.md
9. control/checklist_entrega.md
10. control/avances_rtx.md
```

---

## Resumen ejecutivo

El proyecto actualmente puede describirse así:

```text
Reception Agent ClaustroSF es un asistente hotelero académico en n8n que combina IA local con Ollama, PostgreSQL y lógica en JavaScript para responder preguntas documentales, consultar métricas, revisar disponibilidad, recordar preferencias del usuario y registrar reservas demo de forma controlada.
```