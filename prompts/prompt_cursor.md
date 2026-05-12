# Uso de Cursor en este proyecto

**Repositorio:** proyecto-n8n-hotel-ClaustroSF (**ClaustroSF**). Dominio: **Hotel El Claustro de San Francisco**.

## Qué puede hacer Cursor aquí

- Editar **documentación** (`docs/`, `README.md`, `documentos/`, `prompts/`, `control/`) con coherencia de nombres y tono académico en español.
- Ayudar a redactar pruebas, riesgos o guiones de demo **sin inventar** resultados de laboratorio: use marcadores **[PENDIENTE RTX]** cuando falten datos reales.
- Explicar errores de Docker, n8n u Ollama a partir de logs que pegue en el chat.

## Qué debe evitarse en el asistente de código

- **No** pida modificar `docker-compose.yml` sin revisión humana si el curso exige trazabilidad de infraestructura.
- **No** sobrescriba `workflows/asistente_hotel_basico_qwen.json` sin que el equipo lo decida: es el entregable de referencia del flujo; cualquier cambio debe reexportarse desde n8n y validarse.
- **No** introduzca secretos (tokens, `.env` con valores reales) en archivos versionados.

## Flujo de trabajo recomendado

1. Abrir la carpeta raíz del clon en Cursor (donde está `docker-compose.yml`).
2. Cambios de lógica del flujo: hacerlos **en la UI de n8n**, probar, luego **exportar** JSON a `workflows/` si corresponde.
3. Cambios de texto del hotel: actualizar `documentos/Documento_Base_Hotel.md` y, si aplica, `prompts/prompt_asistente_hotelero.md` y el prompt en n8n.
4. Antes de commit: `git status`, revisar que no aparezcan `.env`, credenciales ni carpetas de datos de Docker.

## Contexto útil para el chat

Indique en el mensaje: versión de Docker Desktop, si usa RTX 3050, modelo `qwen2.5:7b`, y el síntoma exacto (puerto, captura de error). Así las sugerencias serán acotadas al stack del curso.
