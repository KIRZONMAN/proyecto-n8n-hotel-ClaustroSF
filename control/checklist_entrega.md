# Checklist de entrega

Proyecto **proyecto-n8n-hotel-ClaustroSF** (**ClaustroSF**). Hotel: **Hotel El Claustro de San Francisco**. Curso: Modelado Computacional.

Marque `[x]` cuando el ítem esté cumplido. No invente evidencias: si falta material, deje `[ ]` y anote **[PENDIENTE RTX]** donde corresponda.

## Repositorio y seguridad

- [ ] El remoto de GitHub apunta al repositorio correcto (nombre acordado con el profesor).
- [ ] No existe archivo **`.env`** versionado; solo **`.env.example`** sin secretos reales.
- [ ] No hay tokens, contraseñas ni `*credentials*.json` con datos sensibles en el árbol versionado.
- [ ] `.gitignore` cubre volúmenes locales, datos de n8n y artefactos pesados (no modelos Ollama en Git).

## Código y configuración

- [ ] `docker-compose.yml` revisado por el equipo (sin credenciales en texto claro).
- [ ] `workflows/asistente_hotel_basico_qwen.json` presente y **sin** credenciales de n8n embebidas.
- [ ] El nombre formal del hotel es coherente en **documentación** y `documentos/Documento_Base_Hotel.md`.

## Funcionalidad mínima (RTX 3050 u equipo designado)

- [ ] `docker compose up -d` deja `n8n` y `ollama` en ejecución.
- [ ] Modelo `qwen2.5:7b` disponible en Ollama.
- [ ] Workflow importado ejecuta hasta el nodo HTTP y recibe respuesta en `response`.

## Documentación

- [ ] `README.md` actualizado (qué hace el proyecto, stack, cómo levantar, limitaciones, mejoras futuras).
- [ ] `docs/arquitectura.md`, `docs/explicacion_demo.md`, `docs/plan_trabajo.md`, `docs/riesgos_y_limitaciones.md` y `docs/pruebas_funcionales.md` revisados.
- [ ] `prompts/prompt_asistente_hotelero.md` contiene el prompt base alineado al hotel.

## Pruebas y evidencias

- [ ] Se ejecutaron las pruebas de `docs/pruebas_funcionales.md` y se actualizaron tablas con resultados reales (sustituir **[PENDIENTE RTX]** donde aplique).
- [ ] Carpeta `evidencias/` con capturas o enlaces acordados con el profesor (sin datos sensibles en imágenes).

## Declaración de alcance (para la defensa)

- [ ] El equipo puede explicar que **no** están implementados: AI Agent, Telegram, PDF automático, Google Docs ni base vectorial; solo constan como **mejoras futuras** en la documentación.
