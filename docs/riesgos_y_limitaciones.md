# Riesgos y limitaciones

Proyecto:

```text
Reception Agent ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

---

## 1. Propósito del documento

Este documento registra los riesgos, limitaciones y pendientes del sistema actual.

El proyecto es un prototipo académico. No debe presentarse como un sistema listo para producción real en un hotel.

---

## 2. Alcance real del sistema

El sistema actual sí permite:

- Clasificar preguntas.
- Consultar documentación del hotel.
- Consultar métricas del dataset.
- Consultar disponibilidad simple.
- Guardar memoria personalizada.
- Usar memoria en reservas.
- Registrar reservas demo.
- Validar disponibilidad.
- Validar presupuesto.
- Responder de forma segura ante solicitudes fuera de alcance.

El sistema actual no permite:

- Procesar pagos reales.
- Confirmar reservas reales ante un PMS hotelero.
- Autenticar usuarios reales.
- Enviar correos reales de confirmación.
- Integrarse con WhatsApp o Telegram.
- Operar en producción.
- Garantizar disponibilidad real por fechas.
- Recomendar habitaciones con consultoría avanzada completa.

---

## 3. Riesgo: interpretación incorrecta de IA

### Descripción

La IA puede interpretar mal frases ambiguas del usuario.

Ejemplo:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

La IA podría proponer erróneamente:

```text
tipo_habitacion_preferida = sencilla
vista_preferida = tranquilas
```

### Mitigación

Existe el nodo:

```text
Code - Validar Memoria Usuario JSON
```

Este nodo descarta campos dudosos antes de guardar en PostgreSQL.

El sistema sigue el enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

---

## 4. Riesgo: guardar memoria contaminada

### Descripción

Como la memoria funciona por `session_id`, una sesión de prueba puede acumular datos anteriores.

Ejemplo:

```text
session_id = demo-claustrosf
```

puede contener memoria vieja de pruebas anteriores.

### Mitigación

Se puede limpiar la memoria demo con:

```sql
DELETE FROM memoria_usuario_demo
WHERE session_id = 'demo-claustrosf';
```

Además, el sistema confirma qué memoria queda guardada.

---

## 5. Riesgo: uso excesivo de IA

### Descripción

Si todo el workflow pasara por IA, aumentaría el costo computacional, el tiempo de respuesta y la posibilidad de errores.

### Mitigación

El workflow clasifica antes de llamar IA.

Solo se usa IA principalmente en:

```text
consulta documental
extracción de memoria personalizada
```

No se usa IA para:

```text
analítica
disponibilidad simple
reserva demo
validación de presupuesto
registro en base de datos
respuesta segura
```

---

## 6. Riesgo: contexto documental excesivo

### Descripción

Enviar todo el documento base al agente puede aumentar tokens y reducir precisión.

### Mitigación

Se agregó:

```text
Code - Preparar Contexto Documental
```

Este nodo selecciona secciones relevantes antes de llamar al agente documental.

---

## 7. Riesgo: respuesta documental incompleta

### Descripción

Si el selector de contexto no selecciona una sección relevante, el agente puede responder que no tiene información suficiente.

### Mitigación

El nodo de preparación documental usa palabras clave y puntuación de secciones.

Aun así, es una limitación actual. En el futuro podría mejorarse con RAG vectorial o `pgvector`.

---

## 8. Riesgo: reserva demo confundida con reserva real

### Descripción

El usuario podría interpretar que una reserva demo es una reserva real.

### Mitigación

Las respuestas deben indicar que es un entorno académico/demo.

El sistema no maneja pagos, usuarios reales ni confirmación externa.

---

## 9. Riesgo: disponibilidad no basada en calendario

### Descripción

La disponibilidad actual se basa en el estado general de una habitación:

```text
disponible
reservada
ocupada
mantenimiento
```

No se valida un rango real de fechas.

### Limitación

Una habitación marcada como `reservada` se considera no disponible de forma general, aunque en un sistema real podría estar disponible en otras fechas.

### Mejora futura

Implementar una tabla de calendario o intervalos de reserva:

```text
habitacion_id
fecha_inicio
fecha_fin
estado
```

---

## 10. Riesgo: concurrencia en reservas

### Descripción

En un sistema real, dos usuarios podrían intentar reservar la misma habitación al mismo tiempo.

### Estado actual

El proyecto es demo y no está diseñado para alta concurrencia.

### Mitigación parcial

El SQL de registro valida el estado de la habitación antes de actualizarla.

### Mejora futura

Usar transacciones más estrictas, bloqueos o control de concurrencia.

---

## 11. Riesgo: credenciales en repositorio

### Descripción

Un workflow exportado podría contener referencias a credenciales.

### Mitigación

Antes de subir a GitHub:

- Revisar el JSON exportado.
- No subir `.env` real.
- No subir credenciales de n8n.
- Usar `.env.example`.
- Usar `.gitignore`.

---

## 12. Riesgo: módulo de consultoría incompleto

### Descripción

El sistema ya clasifica preguntas de recomendación como:

```text
consultoria
```

Ejemplo:

```text
¿Qué habitación me recomiendas para viajar con mi familia?
```

Pero todavía no tiene un módulo especializado de recomendación.

### Estado actual

La consultoría se enruta a:

```text
Code - Respuesta Segura
```

### Mejora futura

Crear una rama propia:

```text
consultoria
→ consultar memoria
→ consultar disponibilidad
→ aplicar reglas de recomendación
→ opcionalmente usar IA
→ responder recomendación
```

---

## 13. Riesgo: dependencia del modelo local

### Descripción

El sistema usa Ollama y `llama3:latest`.

El rendimiento depende de:

- CPU.
- GPU.
- RAM.
- Configuración de Ollama.
- Tamaño del prompt.
- Carga del equipo.

### Mitigación

Se redujo el uso de IA a módulos específicos y se optimizó el contexto documental.

---

## 14. Riesgo: respuestas variables de IA

### Descripción

Aunque el prompt sea estricto, el modelo puede variar sus respuestas.

### Mitigación

- Validación posterior.
- Limpieza de salida.
- Prompts restrictivos.
- Separación entre IA y acciones críticas.
- Reglas de negocio en Code y PostgreSQL.

---

## 15. Limitación: sin autenticación real

El sistema no identifica usuarios reales.

La memoria funciona por:

```text
session_id
```

Esto es suficiente para demo, pero no para producción.

Mejora futura:

```text
usuarios autenticados
sesiones reales
perfiles persistentes
control de privacidad
```

---

## 16. Limitación: sin canal externo

Actualmente el sistema se ejecuta desde n8n.

No hay todavía integración con:

```text
Telegram
WhatsApp
Web chat
Aplicación móvil
Frontend web
```

---

## 17. Limitación: sin RAG vectorial

La consulta documental usa selección de contexto por reglas y palabras clave.

No se ha implementado:

```text
embeddings
pgvector
búsqueda semántica
fragmentación avanzada
ranking vectorial
```

---

## 18. Limitación: dataset académico

El dataset hotelero se usa para analítica demo.

No representa necesariamente operaciones reales del Hotel El Claustro de San Francisco.

---

## 19. Limitación: documentación y evidencias en evolución

La documentación se está actualizando para alinearse con el workflow real.

Riesgo:

```text
Algunos documentos pueden mencionar versiones antiguas si no se actualizan.
```

Mitigación:

```text
Revisar documentos antes del commit final.
```

---

## 20. Pendientes principales

Pendientes técnicos:

- Exportar workflow final desde n8n.
- Revisar JSON exportado.
- Actualizar toda la documentación.
- Preparar evidencias visuales finales.
- Crear módulo propio de consultoría.
- Mejorar manejo de fechas.
- Mejorar disponibilidad por calendario.
- Añadir pruebas automatizadas.
- Preparar guion de sustentación.

Pendientes funcionales:

- Consultoría avanzada.
- Cancelación de reservas demo.
- Confirmación explícita antes de reservar.
- Borrado de memoria desde conversación.
- Frontend o canal externo.
- RAG vectorial.

---

## 21. Estado actual de riesgos

| Riesgo | Estado |
|---|---|
| IA interpreta mal memoria | Mitigado con validación Code |
| Exceso de tokens documental | Mitigado con contexto reducido |
| Reserva real confundida con demo | Debe aclararse en respuestas y demo |
| Consultoría incompleta | Pendiente controlado |
| Disponibilidad sin calendario | Limitación aceptada |
| Credenciales en GitHub | Requiere revisión antes de commit |
| Memoria por session_id | Aceptable para demo |
| Falta de frontend | Pendiente futuro |

---

## 22. Conclusión

El sistema actual es adecuado para una demostración académica avanzada.

Sus mayores fortalezas son:

- Modularidad.
- Clasificación previa.
- IA local controlada.
- PostgreSQL como base operacional.
- Memoria personalizada validada.
- Reserva demo inteligente.
- Optimización documental.
- Respuestas seguras.

Sus mayores pendientes son:

- Consultoría hotelera avanzada.
- Disponibilidad real por fechas.
- Canales externos.
- Autenticación.
- Preparación final de evidencias y demo.