# Arquitectura del sistema

Proyecto **proyecto-n8n-hotel-ClaustroSF** (abreviatura **ClaustroSF**). Dominio documentado: **Hotel El Claustro de San Francisco**.

## 1. Vista general

El sistema es un prototipo académico de **asistente hotelero** compuesto por tres piezas principales que se ejecutan en contenedores Docker sobre la misma red de Compose:

1. **n8n** — editor y motor de ejecución de workflows.
2. **Ollama** — servidor de inferencia para modelos locales.
3. **Docker Compose** — definición declarativa de servicios, puertos y volúmenes persistentes.

```
┌─────────────┐     HTTP (red Docker)      ┌─────────────┐
│    n8n      │  POST /api/generate        │   Ollama    │
│  (workflow) │ ─────────────────────────► │ qwen2.5:7b  │
└─────────────┘                            └─────────────┘
       │                                           │
       │ volúmenes locales                         │ volumen de modelos
       ▼                                           ▼
   n8n_data                                   ollama_data
```

Los datos persistentes de n8n y los pesos del modelo **no** forman parte del repositorio Git; viven en volúmenes gestionados por Docker en la máquina anfitriona (p. ej. PC **RTX 3050**).

## 2. Flujo de datos en la versión actual

1. El usuario (o el docente en demo) ejecuta el workflow desde **Manual Trigger**.
2. El nodo **Set** (Edit Fields) define la variable de pregunta (ej. `pregunta_usuario`).
3. El nodo **HTTP Request** envía a Ollama un JSON con:
   - `model`: `qwen2.5:7b`
   - `prompt`: texto del sistema + **contexto resumido del hotel** + pregunta.
   - `stream`: `false`
4. Ollama devuelve JSON; la respuesta generada suele aparecer en el campo `response`.

Esta versión **no** incluye recuperación desde base vectorial ni lectura dinámica de archivos PDF o Google Docs: el contexto útil va **directo en el prompt**.

## 3. Documentación de dominio

La fuente de verdad para políticas, habitaciones y servicios es `documentos/Documento_Base_Hotel.md`. Las pruebas funcionales en `docs/pruebas_funcionales.md` se alinean a ese documento.

## 4. Límites arquitectónicos actuales

- Un solo modelo local; sin balanceo ni caché de respuestas.
- Sin colas de mensajes externos (no hay Telegram ni webhooks públicos en el alcance actual).
- Sin **AI Agent** de n8n: el grafo es lineal (disparador → campos → HTTP).

## 5. Evolución prevista (no implementada)

- Capa de **embeddings** y almacén vectorial (**Postgres/pgvector** u otro).
- **AI Agent** y herramientas adicionales.
- Conectores a **PDF**, **Google Docs** o bases de datos operativas, según decisión del curso.

Estas líneas son **orientación** para informes y defensa oral; el código y el workflow exportado reflejan solo la arquitectura básica descrita arriba.
