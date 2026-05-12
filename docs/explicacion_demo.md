# Explicación para la demostración (demo en clase)

**Repositorio:** proyecto-n8n-hotel-ClaustroSF (**ClaustroSF** = abreviatura). **Hotel:** Hotel El Claustro de San Francisco.

## Objetivo de la demo (2–4 minutos)

Mostrar que el stack **Docker Compose + n8n + Ollama** está operativo y que el workflow exportado puede **consultar al modelo local** y obtener una respuesta coherente con el contexto del hotel definido en la documentación.

## Antes de la sesión

1. PC RTX 3050 (o equivalente) con Docker en ejecución.
2. `docker compose up -d` en la carpeta del proyecto.
3. Modelo descargado: `docker compose exec ollama ollama pull qwen2.5:7b`
4. Workflow importado en n8n desde `workflows/asistente_hotel_basico_qwen.json`.

## Guión sugerido

1. **Mostrar Compose:** `docker compose ps` — deben verse servicios `n8n` y `ollama` en estado running (evidencia: [PENDIENTE RTX] hasta capturar).
2. **Abrir n8n** en el navegador (`http://localhost:5678`).
3. **Abrir el workflow** importado y explicar en voz alta los tres nodos: disparador manual → edición de campos → petición HTTP a Ollama.
4. **Ejecutar** el flujo y señalar en la salida el campo de respuesta del modelo (`response`).
5. **Opcional:** cambiar la pregunta de prueba en el nodo *Edit Fields* a una línea de `documentos/Preguntas_Prueba_Hotel.md` y volver a ejecutar.

## Qué no se debe afirmar en la demo

No diga que el proyecto ya incluye **AI Agent**, **Telegram**, lectura automática de **PDF**, **Google Docs** ni **base vectorial**: no forman parte de la versión actual; solo figuran como mejoras futuras en el README y en `docs/plan_trabajo.md`.

## Si algo falla

- Ollama sin modelo: ejecutar `ollama pull qwen2.5:7b` dentro del contenedor.
- n8n no alcanza Ollama: comprobar que la URL del nodo sea la interna de Compose (`http://ollama:11434/api/generate`) y que ambos servicios estén en el mismo `docker compose`.

## Evidencias

Las capturas esperadas están listadas en `docs/pruebas_funcionales.md` y en `evidencias/` — reemplazar referencias **[PENDIENTE RTX]** con archivos reales cuando estén disponibles.
