# Checklist de entrega

Proyecto:

```text
Reception Agent ClaustroSF
```

Repositorio:

```text
proyecto-n8n-hotel-ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

Curso:

```text
Modelado Computacional
```

---

## 1. Repositorio y seguridad

- [ ] El repositorio remoto de GitHub apunta al proyecto correcto.
- [ ] No existe archivo `.env` versionado con credenciales reales.
- [ ] Existe `.env.example` sin secretos reales, si aplica.
- [ ] No hay tokens, contraseñas, claves privadas ni credenciales de n8n dentro del repositorio.
- [ ] No hay archivos `credentials.json`, backups sensibles o dumps privados versionados.
- [ ] `.gitignore` cubre archivos temporales, volúmenes locales, datos de n8n, credenciales y artefactos pesados.
- [ ] El workflow exportado fue revisado antes de subirlo a GitHub.

---

## 2. Workflow principal

- [x] Existe un workflow principal avanzado en n8n.
- [x] El workflow está organizado visualmente por zonas.
- [x] El workflow incluye clasificación de intención.
- [x] El workflow usa `Switch - Tipo de solicitud`.
- [x] El workflow separa consultas documentales, analítica, reserva, disponibilidad, memoria y respuesta segura.
- [x] El workflow usa PostgreSQL para datos persistentes.
- [x] El workflow usa Ollama como IA local.
- [x] El workflow usa `llama3:latest` como modelo local.
- [ ] El workflow final fue exportado nuevamente desde n8n después de los últimos cambios.
- [ ] El archivo exportado final está actualizado en `workflows/`.
- [ ] El archivo exportado final no contiene credenciales sensibles.

Archivo actual esperado:

```text
workflows/UltimateMKII_Agent_Documental_ClaustroSF.json
```

---

## 3. Zonas funcionales del workflow

- [x] Zona 1 — Entrada y clasificación.
- [x] Zona 2 — Consulta documental con IA.
- [x] Zona 3 — Analítica del dataset.
- [x] Zona 4 — Reserva demo inteligente.
- [x] Zona 5 — Respuesta segura / excepciones.
- [x] Zona 6 — Disponibilidad simple.
- [x] Zona 7 — Memoria personalizada.

---

## 4. Clasificación de intención

- [x] Existe nodo `Code - Normalizar Pregunta`.
- [x] Existe nodo `Code - Clasificar Intención`.
- [x] Se genera el campo `tipo_solicitud`.
- [x] Se genera `confianza_clasificacion`.
- [x] Se genera `motivo_clasificacion`.
- [x] Se genera `score_clasificacion`.
- [x] El `Switch - Tipo de solicitud` enruta correctamente al menos los casos principales.
- [x] Se evita enviar todo a IA innecesariamente.

Tipos de solicitud considerados:

- [x] `documental`
- [x] `analitica_dataset`
- [x] `reserva_simulada`
- [x] `fuera_alcance`
- [x] `disponibilidad_habitaciones`
- [x] `consultoria`
- [x] `memoria_usuario`

---

## 5. Consulta documental con IA

- [x] El módulo documental obtiene el documento base desde GitHub RAW.
- [x] El documento base usado es `documentos/Documento_Base_Hotel.md`.
- [x] Existe nodo `Code - Preparar Contexto Documental`.
- [x] El contexto documental se reduce antes de llegar al agente.
- [x] Existe `AI Agent` para responder preguntas documentales.
- [x] El agente documental usa contexto y no debe inventar información.
- [x] Existe nodo `Code - Formatear Salida Documental`.
- [x] La salida documental contiene `respuesta_final`.
- [x] Se probó una pregunta de política de cancelación.
- [ ] Se documentaron capturas finales del módulo documental en `evidencias/`, si el profesor las exige.

---

## 6. Analítica del dataset

- [x] Existe módulo de analítica del dataset.
- [x] Existe nodo `Postgres - Métricas Dataset`.
- [x] Existe nodo `Code - Formatear Salida Analítica`.
- [x] El módulo devuelve métricas como total de reservas, tasa de cancelación, ADR promedio y lead time promedio.
- [x] El módulo no depende de IA.
- [x] Se probó una consulta tipo: `Muéstrame métricas del dataset`.
- [ ] Se documentaron capturas finales del módulo de analítica en `evidencias/`, si aplica.

---

## 7. Disponibilidad de habitaciones

- [x] Existe módulo de disponibilidad simple.
- [x] Existe nodo `Postgres - Disponibilidad Habitaciones`.
- [x] Existe nodo `Code - Formatear Salida Disponibilidad`.
- [x] El sistema consulta habitaciones por tipo.
- [x] El sistema muestra totales de disponibles, ocupadas, reservadas y mantenimiento.
- [x] El módulo no depende de IA.
- [x] Se probó una consulta tipo: `¿Hay habitaciones familiares disponibles?`.
- [ ] Se documentaron capturas finales del módulo de disponibilidad en `evidencias/`, si aplica.

---

## 8. Memoria personalizada

- [x] Existe módulo de memoria personalizada.
- [x] El módulo está conectado desde el `Switch - Tipo de solicitud`.
- [x] Existe nodo `AI Agent - Extraer Memoria Usuario JSON`.
- [x] Existe nodo `Code - Validar Memoria Usuario JSON`.
- [x] Existe nodo `If - ¿Memoria Válida?`.
- [x] Existe nodo `Postgres - Guardar Memoria Usuario`.
- [x] Existe nodo `Code - Confirmar Memoria Guardada`.
- [x] Existe nodo `Code - Memoria No Guardada`.
- [x] La memoria se guarda en `memoria_usuario_demo`.
- [x] La IA solo extrae JSON.
- [x] El código valida antes de guardar.
- [x] Se descartan campos dudosos o inválidos.
- [x] Se probó guardar nombre.
- [x] Se probó guardar preferencias.
- [x] Se probó guardar número de adultos y niños.
- [x] Se probó guardar presupuesto y vista.
- [ ] Se documentaron capturas finales del módulo de memoria en `evidencias/`, si aplica.

---

## 9. Reserva demo inteligente

- [x] Existe módulo de reserva demo.
- [x] Existe nodo `Code - Extraer Datos Reserva`.
- [x] Existe nodo `Postgres - Consultar Memoria Usuario`.
- [x] Existe nodo `Code - Aplicar Memoria a Reserva`.
- [x] Existe nodo `If - ¿Reserva Completa?`.
- [x] Existe nodo `Code - Pedir Datos Faltantes`.
- [x] Existe nodo `Code - Validar Reserva Completa`.
- [x] Existe nodo `Code - Preparar Consulta Reserva`.
- [x] Existe nodo `Postgres - Buscar Habitación Disponible`.
- [x] Existe nodo `If - ¿Hay disponibilidad?`.
- [x] Existe nodo `Code - Sin Disponibilidad`.
- [x] Existe nodo `If - ¿Cumple presupuesto?`.
- [x] Existe nodo `Code - Fuera de Presupuesto`.
- [x] Existe nodo `Code - Preparar Registro Reserva`.
- [x] Existe nodo `Postgres - Registrar Reserva Demo`.
- [x] Existe nodo `Code - Confirmar Reserva Registrada`.
- [x] El sistema puede registrar reservas demo.
- [x] El sistema puede cambiar habitaciones a estado `reservada`.
- [x] El sistema valida disponibilidad.
- [x] El sistema valida presupuesto.
- [x] El sistema usa memoria para completar datos faltantes.
- [x] Los datos explícitos del usuario tienen prioridad sobre la memoria.
- [ ] Se documentaron capturas finales del módulo de reserva en `evidencias/`, si aplica.

---

## 10. Respuesta segura y excepciones

- [x] Existe nodo `Code - Respuesta Segura`.
- [x] El sistema rechaza preguntas fuera de alcance.
- [x] El sistema evita responder solicitudes inseguras.
- [x] El sistema responde de forma controlada cuando el módulo todavía no está implementado.
- [x] La consultoría hotelera está clasificada, pero responde como módulo pendiente.
- [ ] Se documentaron ejemplos finales de respuesta segura.

---

## 11. Documentación principal

Actualizar o revisar:

- [x] `workflows/README.md`
- [x] `docs/plan_trabajo.md`
- [x] `control/checklist_entrega.md`
- [x] `control/avances_rtx.md`
- [x] `docs/README.md`
- [ ] `docs/arquitectura.md`
- [ ] `docs/pruebas_funcionales.md`
- [ ] `docs/explicacion_demo.md`
- [ ] `docs/memoria_usuario.md`
- [ ] `docs/riesgos_y_limitaciones.md`
- [ ] `README.md`
- [ ] `evidencias/README.md`
- [ ] `evidencias/pendientes.txt`
- [ ] `documentos/Preguntas_Prueba_Hotel.md`

---

## 12. Evidencias recomendadas

Guardar capturas de:

- [ ] Workflow completo por zonas.
- [ ] Switch con las siete salidas.
- [ ] Consulta documental funcionando.
- [ ] Analítica del dataset funcionando.
- [ ] Disponibilidad funcionando.
- [ ] Memoria guardada correctamente.
- [ ] Memoria descartando campos inválidos.
- [ ] Reserva demo registrada.
- [ ] Caso sin disponibilidad.
- [ ] Caso fuera de presupuesto.
- [ ] Respuesta segura para fuera de alcance.
- [ ] Consultoría respondiendo como módulo pendiente.

---

## 13. Declaración de alcance para sustentación

El equipo debe poder explicar que el proyecto actual sí implementa:

- Automatización con n8n.
- IA local con Ollama.
- Clasificación de intención.
- Consulta documental.
- Optimización de contexto.
- PostgreSQL como base operacional.
- Analítica del dataset.
- Disponibilidad de habitaciones.
- Memoria personalizada.
- Reserva demo inteligente.
- Validaciones de seguridad y negocio.

El equipo debe aclarar que todavía no implementa:

- Pagos reales.
- Confirmaciones reales por correo.
- Integración con sistemas hoteleros reales.
- Autenticación de usuarios reales.
- Telegram o WhatsApp.
- RAG vectorial avanzado.
- Consultoría hotelera completa.
- Producción real para un hotel.

---

## 14. Antes de hacer commit final

- [ ] Ejecutar pruebas mínimas de cada módulo.
- [ ] Exportar workflow final desde n8n.
- [ ] Reemplazar el JSON viejo por el nuevo, si aplica.
- [ ] Revisar que no se suban credenciales.
- [ ] Revisar que los documentos no mencionen `qwen2.5:7b` como modelo actual.
- [ ] Revisar que los documentos no describan el flujo antiguo como flujo principal.
- [ ] Confirmar que `llama3:latest` aparece como modelo actual.
- [ ] Confirmar que el módulo de memoria aparece como funcional.
- [ ] Confirmar que el módulo de consultoría aparece como pendiente.