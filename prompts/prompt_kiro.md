# Especificación para Kiro (proyecto ClaustroSF)

Use este bloque como **contexto de producto** al trabajar con Kiro u otra herramienta de especificación asistida. **No** asuma funciones no listadas aquí.

## Identificación

- **Nombre del repositorio:** proyecto-n8n-hotel-ClaustroSF (abreviatura interna: **ClaustroSF**).
- **Nombre formal del hotel en toda la documentación:** Hotel El Claustro de San Francisco.
- **Curso:** Modelado Computacional (proyecto universitario).

## Stack fijo

- Docker Compose con servicios **n8n** y **ollama**.
- Modelo local: **qwen2.5:7b** vía Ollama.
- Endpoint del flujo actual: `POST http://ollama:11434/api/generate` desde n8n (red interna de Compose).

## Comportamiento esperado del software (alcance actual)

1. Importar y ejecutar el workflow exportado `workflows/asistente_hotel_basico_qwen.json`.
2. El usuario dispara manualmente el flujo; un nodo Set define `pregunta_usuario`; el nodo HTTP envía prompt + contexto resumido + pregunta a Ollama.
3. La respuesta debe respetar las reglas del prompt (español, sin inventar, mensaje fijo si falta información en el contexto embebido).

## Fuera de alcance (no implementar salvo nueva fase del curso)

- AI Agent de n8n.
- Telegram u otros canales de chat.
- Lectura automática de PDF o integración con Google Docs.
- Postgres, pgvector u otra base vectorial.
- Cualquier credencial en repositorio: usar `.env` local ignorado por Git.

## Criterios de calidad

- Documentación en **español**, nombres de hotel unificados.
- Sin afirmar que existen integraciones futuras.
- Pruebas documentadas con **[PENDIENTE RTX]** donde no haya evidencia real de la PC de laboratorio.

## Entregables que el equipo debe poder mostrar

- README con instrucciones de levantamiento.
- `docs/pruebas_funcionales.md` con tablas actualizadas cuando existan resultados reales.
- Evidencias en `evidencias/` sin datos sensibles.

## Instrucción para el asistente en Kiro

> Priorice ediciones en Markdown y comentarios; no refactorice `docker-compose.yml` ni el JSON del workflow salvo petición explícita del usuario con revisión y prueba en Docker.
