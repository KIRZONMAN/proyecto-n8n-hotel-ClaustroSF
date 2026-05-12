# proyecto-n8n-hotel-ClaustroSF

Proyecto universitario de **Modelado Computacional**: asistente conversacional para el **Hotel El Claustro de San Francisco** (nombre oficial en documentación). **ClaustroSF** es solo la abreviatura usada en el nombre del repositorio.

## Qué hace el proyecto

Orquesta un flujo en **n8n** que envía una pregunta del usuario (campo fijo o editable en el flujo) a **Ollama** mediante HTTP. El modelo genera una respuesta en español usando **contexto directo incrustado en el prompt**, alineado con la información del archivo `documentos/Documento_Base_Hotel.md`.

No existe aún canal de mensajería para huéspedes ni agente autónomo: la ejecución es manual o por disparadores básicos dentro de n8n.

## Tecnologías

| Componente | Uso |
|------------|-----|
| **Docker Compose** | Servicios `n8n` y `ollama`, red y volúmenes nombrados. |
| **n8n** | Diseño y ejecución del workflow (nodos Manual Trigger, Set, HTTP Request). |
| **Ollama** | Inferencia local del modelo **qwen2.5:7b**. |
| **Markdown** | Documentación, documento base del hotel y pruebas funcionales. |

## Cómo levantar el entorno

1. Clonar el repositorio (nombre remoto típico: `proyecto-n8n-hotel-ClaustroSF`).
2. Opcional: copiar `.env.example` a `.env` solo en su máquina; no subir `.env` a Git.
3. En la raíz del proyecto: `docker compose up -d`
4. Descargar el modelo en el contenedor de Ollama:  
   `docker compose exec ollama ollama pull qwen2.5:7b`
5. Abrir n8n en `http://localhost:5678` (puerto según su `docker-compose.yml`).
6. Importar el JSON de `workflows/asistente_hotel_basico_qwen.json` y ejecutar según `docs/explicacion_demo.md` y `docs/pruebas_funcionales.md`.

Los **volúmenes** de Docker (`n8n_data`, `ollama_data`) guardan estado y pesos del modelo **fuera** del repositorio; no deben versionarse.

## Modelo y workflow exportado

- **Modelo local:** `qwen2.5:7b` (Ollama).
- **Endpoint usado en el flujo:** `POST http://ollama:11434/api/generate`
- **Workflow versionado:** `workflows/asistente_hotel_basico_qwen.json` (asistente básico con contexto en el cuerpo JSON del nodo HTTP).

> El JSON exportado es la referencia de entrega; si el texto del prompt dentro del archivo no coincide aún con el nombre oficial del hotel en la documentación, actualicen el flujo en n8n y exporten de nuevo cuando corresponda.

## Estado actual

- Infraestructura descrita: Compose + n8n + Ollama.
- Asistente en versión **básica**: contexto resumido en el prompt del nodo HTTP; sin base vectorial, sin lectura real de PDF, sin Google Docs, sin Telegram y **sin nodo AI Agent**.
- Pruebas funcionales y evidencias: tablas y listas preparadas; resultados y capturas reales marcados como **[PENDIENTE RTX]** hasta ejecutarlas en la PC RTX 3050.

## Limitaciones

- El modelo puede **alucinar** o mezclar detalles aunque existan reglas en el prompt.
- El **contexto largo en el prompt** no escala: documentos extensos no caben de forma fiable.
- La solución depende de que **Docker y Ollama** estén operativos en la máquina de ejecución (RTX 3050 prevista).
- Sin recuperación semántica (RAG): no hay Postgres/pgvector ni otro vector store en esta versión.

## Mejoras futuras (solo planificadas)

- Lectura y uso de **documentos externos** (PDF u otros) con pipeline definido.
- **AI Agent** en n8n u orquestación equivalente para diálogo multi-paso.
- **Postgres + pgvector** u otra **base vectorial** para RAG.
- Integraciones opcionales: **Telegram**, **Google Docs**, u otros canales (no implementados).

## Documentación y seguridad

- Índice de carpetas: `docs/README.md`, `workflows/README.md`, `documentos/README.md`, `prompts/README.md`, `evidencias/README.md`, `control/README.md`.
- **No** subir `.env`, tokens, llaves privadas, exportaciones con credenciales de n8n, ni carpetas de modelos Ollama. Ver `.gitignore` y `.env.example`.

## Sobre `docker-compose.yml`

Este README no modifica el archivo Compose; cualquier cambio futuro (por ejemplo `env_file`) debe revisarse y probarse en local antes de publicarlo.
