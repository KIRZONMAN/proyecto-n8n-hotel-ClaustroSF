# Plan de trabajo

Proyecto académico **proyecto-n8n-hotel-ClaustroSF** — asistente para **Hotel El Claustro de San Francisco** (nombre formal). **ClaustroSF** es solo abreviatura del repositorio.

## Fases del curso (estado orientativo)

| Fase | Descripción | Estado |
|------|-------------|--------|
| **Fase 1** | Infraestructura **Docker Compose + n8n + Ollama**; red y volúmenes; modelo `qwen2.5:7b` disponible. | Avance según `control/avances_rtx.md` y evidencias [PENDIENTE RTX]. |
| **Fase 2** | Asistente **básico** con **contexto directo** en el prompt del nodo HTTP; workflow exportado en `workflows/`. | Diseño alineado a documentación; validación en laboratorio pendiente de evidencias. |
| **Fase 3** | **Pruebas funcionales** documentadas y ejecutadas en la RTX 3050 según `docs/pruebas_funcionales.md`. | Tablas con resultados reales: [PENDIENTE RTX]. |
| **Fase 4** | **Documentación** (`docs/`, `README.md`) y **evidencias** (capturas, notas) en `evidencias/`. | En curso / revisión continua. |
| **Fase futura** | Lectura de **documentos externos** (p. ej. PDF) integrada al flujo con criterios de gobernanza del curso. | No implementada. |
| **Fase futura** | **AI Agent** en n8n (o patrón equivalente) para diálogo y herramientas. | No implementada. |
| **Fase futura** | **Postgres** con **pgvector** u otra **base vectorial** para RAG y escalado del contexto. | No implementada. |

## Dependencias entre fases

- La Fase 3 depende de la Fase 1 y 2.
- La Fase 4 puede avanzar en paralelo, pero las evidencias finales requieren pruebas reales (Fase 3).

## Entregables asociados

- Código y configuración versionados (sin `.env` ni modelos).
- Workflow JSON sin credenciales.
- Documento base del hotel y plan de pruebas actualizados.

Las fechas concretas las define el calendario del curso de Modelado Computacional.
