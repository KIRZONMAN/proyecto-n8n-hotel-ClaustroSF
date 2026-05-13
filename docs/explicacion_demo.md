# Explicación para la demostración (demo en clase)

**Repositorio:** proyecto-n8n-hotel-ClaustroSF (**ClaustroSF** = abreviatura). **Hotel:** Hotel El Claustro de San Francisco.

## Objetivo de la demo (2–4 minutos)

Mostrar que el stack **Docker Compose + n8n + Ollama** está operativo y que el workflow puede **llamar al modelo local qwen2.5:7b** y obtener una respuesta coherente con el contexto del hotel definido en la documentación.

## Antes de la sesión

1. PC RTX 3050 (o equivalente) con Docker en ejecución.
2. `docker compose up -d` en la carpeta del proyecto.
3. Modelo descargado: `docker compose exec ollama ollama pull qwen2.5:7b`
4. Workflow importado en n8n desde **`workflows/asistente_hotel_basico_qwen.json`** (archivo oficial en el repositorio).

## Guión sugerido

1. **Mostrar Compose:** `docker compose ps` — servicios `n8n` y `ollama` en estado running (evidencias de captura, si las pide el profesor, pueden mostrarse desde la PC sin subirlas al repo).
2. **Abrir n8n** en el navegador (`http://localhost:5678`).
3. **Abrir el workflow** y explicar la cadena real: **Manual Trigger** → **Edit Fields** (pregunta y campos) → **Code in JavaScript** (construcción del JSON y **`this.helpers.httpRequest`** hacia Ollama).
4. **Motivo del Code Node (opcional en una frase):** el nodo HTTP Request dio problemas con el envío del JSON a Ollama (p. ej. `stream: false`); el código asegura el cuerpo de la petición esperado.
5. **Ejecutar** el flujo y señalar la salida donde se vea la respuesta del modelo (típicamente el campo `response` de Ollama).
6. **Opcional:** cambiar la pregunta de prueba en *Edit Fields* usando una línea de `documentos/Preguntas_Prueba_Hotel.md` y volver a ejecutar.

## Qué no se debe afirmar en la demo

No diga que el proyecto ya incluye **AI Agent**, **Telegram**, lectura automática de **PDF**, **Google Docs** ni **base vectorial**: no forman parte de la versión actual; solo figuran como mejoras futuras en el README y en `docs/plan_trabajo.md` / `docs/pruebas_funcionales.md`.

## Si algo falla

- Ollama sin modelo: ejecutar `ollama pull qwen2.5:7b` dentro del contenedor.
- n8n no alcanza Ollama: comprobar que la URL en el código sea la interna de Compose (`http://ollama:11434/...`) y que ambos servicios estén en el mismo `docker compose`.
- Errores 400 en la API: revisar en el Code Node que el JSON incluya `model`, `prompt` y los flags necesarios (p. ej. `stream: false`).

## Evidencias

Por acuerdo del equipo, las capturas **no** se publican en Git en esta fase; se conservan en la **PC RTX** y en la **conversación de trabajo**. El estado de **PF-01 a PF-10** está registrado en `docs/pruebas_funcionales.md`.
