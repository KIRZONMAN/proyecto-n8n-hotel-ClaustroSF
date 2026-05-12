# Riesgos y limitaciones

Ámbito: proyecto **proyecto-n8n-hotel-ClaustroSF** (**ClaustroSF**), dominio **Hotel El Claustro de San Francisco**. Curso de Modelado Computacional; ejecución principal prevista en **PC RTX 3050**.

## 1. Riesgos del modelo de lenguaje

- **Alucinaciones:** el modelo local (**qwen2.5:7b**) puede inventar o deformar información aunque el prompt imponga reglas (responder solo con el contexto, no inventar, etc.).
- **Sensibilidad al prompt:** pequeños cambios en el texto del sistema o del contexto pueden alterar el tono o la adherencia a políticas del hotel.
- **Límite de contexto:** fragmentos muy largos no caben de forma segura en una sola petición; el resumen embebido puede omitir matices presentes en `documentos/Documento_Base_Hotel.md`.

## 2. Limitaciones de la arquitectura actual

- **Contexto directo en el prompt** no escala: no es adecuado para bases documentales grandes ni para actualizaciones frecuentes sin redesplegar o reeditar el flujo.
- **Sin base vectorial:** no hay recuperación semántica (RAG); no se usa Postgres/pgvector ni otro vector store en esta versión.
- **Sin lectura real de PDF:** el flujo no ingiere archivos PDF dinámicamente; cualquier contenido útil debe estar en el prompt o en texto accesible al diseñador del flujo.
- **Sin Google Docs integrado:** no hay sincronización ni lectura automática de documentos en la nube.
- **Sin Telegram (ni otros canales similares):** no hay bot ni webhook de mensajería en el alcance actual.
- **Sin AI Agent:** no se usa el nodo o patrón AI Agent de n8n; el workflow es un encadenamiento simple hasta la llamada HTTP a Ollama.

## 3. Dependencia operativa

- El sistema **depende de Docker y de Ollama** funcionando correctamente en la máquina de ejecución. Si el contenedor de Ollama cae o el modelo no está descargado, n8n no obtendrá respuesta válida.
- La GPU mejora la latencia de inferencia, pero la validez funcional sigue ligada a la configuración de red entre contenedores y a los recursos disponibles.

## 4. Riesgos de gobernanza y datos

- Exportaciones de n8n mal filtradas podrían incluir **credenciales**; el equipo debe exportar sin secretos y revisar antes de `git push`.
- Evidencias en imagen podrían filtrar **sesiones** o **tokens** en la barra de direcciones; revisar antes de publicar.

## 5. Mitigaciones ya adoptadas en el repositorio

- `.gitignore` orientado a excluir `.env`, datos de n8n, volúmenes locales y artefactos pesados.
- Pruebas funcionales y de “fuera de contexto” definidas en `docs/pruebas_funcionales.md` para detectar respuestas inadecuadas cuando se ejecuten en la RTX.

## 6. Dirección futura (no mitiga el riesgo hoy)

Las mejoras planificadas (RAG con pgvector, AI Agent, integración con documentos externos o canales como Telegram) están **documentadas como futuras**; no sustituyen controles ni pruebas en la versión actual.
