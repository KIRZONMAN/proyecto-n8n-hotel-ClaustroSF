# proyecto-n8n-hotel-ClaustroSF

Proyecto universitario de **Modelado Computacional**: asistente conversacional para el **Hotel El Claustro de San Francisco** (nombre oficial en documentación). **ClaustroSF** es solo la abreviatura usada en el nombre del repositorio.

## Qué hace el proyecto

Orquesta un flujo en **n8n** que toma una pregunta del usuario (campo definido en **Edit Fields**) y la envía a **Ollama** para que el modelo **qwen2.5:7b** genere una respuesta en español. El cuerpo de la petición y el **contexto del hotel** se construyen en un nodo **Code in JavaScript**, que llama a Ollama mediante **`this.helpers.httpRequest`** hacia `http://ollama:11434/api/generate`. Se adoptó el Code Node porque el nodo **HTTP Request** presentó problemas al enviar correctamente el JSON a Ollama (en particular con valores booleanos como `stream: false`).

No existe aún canal de mensajería para huéspedes ni agente autónomo: la ejecución es manual o por disparadores básicos dentro de n8n.

## Tecnologías

| Componente | Uso |
|------------|-----|
| **Docker Compose** | Servicios `n8n` y `ollama`, red y volúmenes nombrados. |
| **n8n** | Workflow: **Manual Trigger** → **Edit Fields** → **Code in JavaScript** → llamada a Ollama. |
| **Ollama** | Inferencia local del modelo **qwen2.5:7b**. |
| **Markdown** | Documentación, documento base del hotel y pruebas funcionales. |

## Cómo levantar el entorno

1. Clonar el repositorio (nombre remoto típico: `proyecto-n8n-hotel-ClaustroSF`).
2. Opcional: copiar `.env.example` a `.env` solo en su máquina; no subir `.env` a Git.
3. En la raíz del proyecto: `docker compose up -d`
4. Descargar el modelo en el contenedor de Ollama:  
   `docker compose exec ollama ollama pull qwen2.5:7b`
5. Abrir n8n en `http://localhost:5678` (puerto según su `docker-compose.yml`).
6. Importar el JSON oficial **`workflows/asistente_hotel_basico_qwen.json`** y ejecutar según `docs/explicacion_demo.md` y `docs/pruebas_funcionales.md`.

Los **volúmenes** de Docker (`n8n_data`, `ollama_data`) guardan estado y pesos del modelo **fuera** del repositorio; no deben versionarse.

## Modelo y workflow exportado

- **Modelo local:** `qwen2.5:7b` (Ollama).
- **Invocación:** `POST http://ollama:11434/api/generate` desde el **Code Node** (`this.helpers.httpRequest`).
- **Workflow oficial (nombre de archivo en repo):** `workflows/asistente_hotel_basico_qwen.json` — debe reflejar el flujo con Code Node; **reexportar** desde n8n tras cambios locales para mantener el repositorio alineado.

> Si el JSON versionado aún muestra un grafo antiguo (p. ej. HTTP Request), actualicen el flujo en n8n y vuelvan a exportar a `workflows/asistente_hotel_basico_qwen.json`.

## Estado actual

- Infraestructura: Compose + n8n + Ollama.
- Asistente en versión **básica**: contexto en el prompt dentro del **Code Node**; sin base vectorial, sin lectura real de PDF, sin Google Docs, sin Telegram y **sin AI Agent**.
- **PF-01 a PF-10** ejecutadas y **aprobadas** en la PC RTX; detalle en `docs/pruebas_funcionales.md`. Las evidencias **no** se suben al repositorio en esta fase (conservadas en la RTX y en la conversación de trabajo).

## Limitaciones

- El modelo puede **alucinar** o mezclar detalles aunque existan reglas en el prompt.
- El **contexto largo en el prompt** no escala: documentos extensos no caben de forma fiable.
- La solución depende de que **Docker y Ollama** estén operativos en la máquina de ejecución (RTX 3050 prevista).
- Sin recuperación semántica (RAG): no hay Postgres/pgvector ni otro vector store en esta versión.

## Mejoras futuras (solo planificadas)

- Lectura y uso de **documentos externos** (p. ej. **PDF**) con pipeline definido.
- **Google Docs** u otras fuentes en la nube (no implementado).
- **AI Agent** en n8n u orquestación equivalente para diálogo multi-paso.
- **Postgres + pgvector** u otra **base vectorial** para RAG.
- Integraciones opcionales: **Telegram** u otros canales (no implementados).

## Documentación y seguridad

- Índice de carpetas: `docs/README.md`, `workflows/README.md`, `documentos/README.md`, `prompts/README.md`, `evidencias/README.md`, `control/README.md`.
- **No** subir `.env`, tokens, llaves privadas, exportaciones con credenciales de n8n, ni carpetas de modelos Ollama. Ver `.gitignore` y `.env.example`.

## Sobre `docker-compose.yml`

Este README no modifica el archivo Compose; cualquier cambio futuro (por ejemplo `env_file`) debe revisarse y probarse en local antes de publicarlo.
