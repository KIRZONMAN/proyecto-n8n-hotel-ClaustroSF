# Checklist de entrega

Proyecto **proyecto-n8n-hotel-ClaustroSF** (**ClaustroSF**). Hotel: **Hotel El Claustro de San Francisco**. Curso: Modelado Computacional.

Marque `[x]` cuando el ítem esté cumplido. Ajuste según lo exija el profesor (p. ej. si pide evidencias subidas al repo).

## Repositorio y seguridad

- [ ] El remoto de GitHub apunta al repositorio correcto (nombre acordado con el profesor).
- [ ] No existe archivo **`.env`** versionado; solo **`.env.example`** sin secretos reales.
- [ ] No hay tokens, contraseñas ni `*credentials*.json` con datos sensibles en el árbol versionado.
- [ ] `.gitignore` cubre volúmenes locales, datos de n8n y artefactos pesados (no modelos Ollama en Git).

## Código y configuración

- [ ] `docker-compose.yml` revisado por el equipo (sin credenciales en texto claro). *(No modificar sin acuerdo.)*
- [ ] `workflows/asistente_hotel_basico_qwen.json` presente, **sin** credenciales de n8n embebidas, y reflejando el flujo **Manual Trigger → Edit Fields → Code in JavaScript → Ollama** (`this.helpers.httpRequest`).
- [ ] El nombre formal del hotel es coherente en **documentación** y `documentos/Documento_Base_Hotel.md`.

## Funcionalidad mínima (PC RTX 3050 u equipo designado)

- [ ] `docker compose up -d` deja `n8n` y `ollama` en ejecución.
- [ ] Modelo `qwen2.5:7b` disponible en Ollama.
- [ ] Workflow importado ejecuta hasta el **Code Node** y obtiene respuesta de Ollama (campo `response`).

## Documentación

- [ ] `README.md` describe el flujo real con **Code Node** (no el nodo HTTP Request como integración principal).
- [ ] `docs/arquitectura.md`, `docs/explicacion_demo.md`, `docs/plan_trabajo.md`, `docs/riesgos_y_limitaciones.md` y `docs/pruebas_funcionales.md` revisados.
- [ ] `prompts/prompt_asistente_hotelero.md` alineado al hotel y al modo de llamada a Ollama.

## Pruebas

- [ ] **PF-01 a PF-10** registradas como aprobadas en `docs/pruebas_funcionales.md` (evidencia: conservada localmente en PC RTX / conversación de trabajo, si no se sube al repo).
- [ ] Resto de pruebas (PF-11+, PS-*, PT-*) según plan del curso.

## Evidencias

- [ ] Material de respaldo (capturas, notas) disponible para el profesor **en la RTX o en el medio acordado**; si el curso no exige subirlas a Git, documentarlo en la entrega escrita.

## Archivos legacy en `workflows/`

- [ ] Si existe `Prueba_Contexto_Hotel_Ollama_copy.json`, se decidió **renombrarlo**, **fusionarlo** con el export oficial o dejarlo como copia de respaldo (sin borrar sin confirmación del equipo).

## Declaración de alcance (defensa)

- [ ] El equipo explica que **no** están implementados: AI Agent, Telegram, PDF automático, Google Docs ni base vectorial; solo figuran como mejoras futuras.
