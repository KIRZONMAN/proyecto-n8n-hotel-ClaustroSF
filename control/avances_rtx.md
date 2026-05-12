# Avances recibidos desde la PC RTX 3050

Máquina principal de ejecución del repositorio **proyecto-n8n-hotel-ClaustroSF** (abreviatura **ClaustroSF**). El nombre formal del hotel en documentación es **Hotel El Claustro de San Francisco**.

## RTX CHECKPOINT 1 — Infraestructura base

**Estado:** pendiente de confirmación final con evidencias adjuntas en `evidencias/`.

### Elementos a confirmar

- [ ] Docker Compose levanta correctamente (`docker compose up -d`).
- [ ] n8n responde en el puerto configurado (por defecto `5678`).
- [ ] Ollama responde en el puerto `11434`.
- [ ] El modelo `qwen2.5:7b` está descargado y visible en `GET /api/tags`.
- [ ] El workflow de prueba o asistente básico está importado y ejecutable en n8n.
- [ ] n8n puede comunicarse con Ollama por la red interna de Compose (`http://ollama:11434`).

### Evidencias pendientes

- [ ] Captura de Docker o salida de `docker compose ps`.
- [ ] Captura del workflow en n8n.
- [ ] Captura de respuesta de Ollama desde el nodo HTTP Request.

Marque con `[x]` cada ítem cuando quede verificado en la RTX y exista evidencia en el repositorio o en la entrega.
