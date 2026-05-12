# Workflows de n8n

Exportaciones JSON del asistente del **Hotel El Claustro de San Francisco** (repositorio **proyecto-n8n-hotel-ClaustroSF**, abreviatura **ClaustroSF**).

## Buenas prácticas al versionar

- Exportar desde n8n **sin credenciales** (revisar el JSON antes de `git commit`).
- URL interna típica hacia Ollama en Compose: `http://ollama:11434/api/generate`.
- Tras importar en otra máquina, confirmar el modelo (`qwen2.5:7b`) con `ollama pull` en el contenedor.

## Coherencia con la documentación

El texto del prompt **dentro** del JSON exportado debe mantenerse alineado con `documentos/Documento_Base_Hotel.md` y con `prompts/prompt_asistente_hotelero.md`. Si el archivo exportado conserva un prompt anterior, actualicen el flujo en n8n y vuelvan a exportar; el repositorio puede versionar el JSON actualizado cuando el equipo lo decida.

## Archivo actual

- `asistente_hotel_basico_qwen.json` — disparador manual, nodo Set con `pregunta_usuario`, HTTP Request a Ollama (`stream: false`).
