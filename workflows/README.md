# Workflows de n8n

Exportaciones JSON del asistente del **Hotel El Claustro de San Francisco** (repositorio **proyecto-n8n-hotel-ClaustroSF**, abreviatura **ClaustroSF**).

## Archivo oficial

El workflow de referencia en el repositorio debe llamarse exactamente:

**`workflows/asistente_hotel_basico_qwen.json`**

El flujo funcional actual es:

**Manual Trigger → Edit Fields → Code in JavaScript → Ollama (`qwen2.5:7b`)**

El **Code Node** usa **`this.helpers.httpRequest`** para llamar a `http://ollama:11434/api/generate`. Sustituye al nodo **HTTP Request** por problemas al enviar el JSON correctamente a Ollama (p. ej. valores booleanos como `stream: false`).

Tras cualquier cambio en n8n, **reexporte** a este nombre de archivo para que Git refleje el estado real.

## Otro archivo en esta carpeta

Si existe **`Prueba_Contexto_Hotel_Ollama_copy.json`** (u otra copia antigua), conviene **renombrarlo** como respaldo local o **reemplazarlo** por el contenido exportado del flujo oficial y guardarlo como `asistente_hotel_basico_qwen.json`, **sin borrar** copias hasta que el equipo confirme que ya no las necesita.

## Buenas prácticas al versionar

- Exportar desde n8n **sin credenciales** (revisar el JSON antes de `git commit`).
- Tras importar en otra máquina, confirmar el modelo (`qwen2.5:7b`) con `ollama pull` en el contenedor.

## Coherencia con la documentación

El texto del prompt y el código dentro del JSON deben mantenerse alineados con `documentos/Documento_Base_Hotel.md` y con `prompts/prompt_asistente_hotelero.md`.
