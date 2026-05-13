# Plan de trabajo

Proyecto académico **proyecto-n8n-hotel-ClaustroSF** — asistente para **Hotel El Claustro de San Francisco** (nombre formal). **ClaustroSF** es solo abreviatura del repositorio.

## Fases del curso (estado orientativo)

| Fase | Descripción | Estado |
|------|-------------|--------|
| **Fase 1** | Infraestructura **Docker Compose + n8n + Ollama**; red y volúmenes; modelo `qwen2.5:7b` disponible. | Operativa en RTX según pruebas del equipo. |
| **Fase 2** | Asistente **básico** con **contexto directo** en el prompt, armado en **Code Node** (JavaScript) con `this.helpers.httpRequest` hacia Ollama; workflow oficial `workflows/asistente_hotel_basico_qwen.json`. | Implementado en RTX; reexportar JSON para alinear repo. |
| **Fase 3** | **Pruebas funcionales** según `docs/pruebas_funcionales.md`. | **PF-01 a PF-10** aprobadas; resto pendiente. Evidencias locales (no en Git en esta fase). |
| **Fase 4** | **Documentación** (`docs/`, `README.md`) y **evidencias** (capturas, notas) en `evidencias/`. | En curso / revisión continua. |
| **Fase futura** | Lectura de **documentos externos** (p. ej. PDF) integrada al flujo con criterios de gobernanza del curso. | No implementada. |
| **Fase futura** | **Google Docs** u otras fuentes documentales en la nube. | No implementada. |
| **Fase futura** | **AI Agent** en n8n (o patrón equivalente) para diálogo y herramientas. | No implementada. |
| **Fase futura** | **Telegram** u otros canales de mensajería. | No implementada. |
| **Fase futura** | **Postgres** con **pgvector** u otra **base vectorial** para RAG y escalado del contexto. | No implementada. |

## Dependencias entre fases

- La Fase 3 depende de la Fase 1 y 2.
- La Fase 4 puede avanzar en paralelo, pero las evidencias finales requieren pruebas reales (Fase 3).

## Entregables asociados

- Código y configuración versionados (sin `.env` ni modelos).
- Workflow JSON sin credenciales.
- Documento base del hotel y plan de pruebas actualizados.

Las fechas concretas las define el calendario del curso de Modelado Computacional.
