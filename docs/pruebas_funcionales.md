# Pruebas funcionales

Proyecto:

```text
Reception Agent ClaustroSF
```

Hotel:

```text
Hotel El Claustro de San Francisco
```

---

## 1. Objetivo

Este documento registra las pruebas funcionales principales del workflow actual.

Las pruebas buscan comprobar que:

- El sistema clasifica correctamente la intención.
- El `Switch - Tipo de solicitud` enruta a la zona adecuada.
- La consulta documental funciona.
- La analítica responde desde PostgreSQL.
- La disponibilidad simple funciona.
- La reserva demo responde correctamente.
- La memoria personalizada guarda datos válidos.
- La validación de memoria descarta errores de IA.
- La respuesta segura controla solicitudes fuera de alcance.
- La consultoría queda clasificada pero pendiente como módulo propio.

---

## 2. Zonas evaluadas

```text
Zona 1 — Entrada y clasificación
Zona 2 — Consulta documental con IA
Zona 3 — Analítica del dataset
Zona 4 — Reserva demo inteligente
Zona 5 — Respuesta segura / excepciones
Zona 6 — Disponibilidad simple
Zona 7 — Memoria personalizada
```

---

## 3. Salidas esperadas del Switch

| Output | Tipo de solicitud | Estado |
|---|---|---|
| 0 | `documental` | Funcional |
| 1 | `analitica_dataset` | Funcional |
| 2 | `reserva_simulada` | Funcional |
| 3 | `fuera_alcance` | Funcional |
| 4 | `disponibilidad_habitaciones` | Funcional |
| 5 | `consultoria` | Clasificado, módulo pendiente |
| 6 | `memoria_usuario` | Funcional |

---

## 4. Pruebas de clasificación y ruteo

### Prueba 1 — Documental

Entrada:

```text
¿Cuáles son las políticas de cancelación del hotel?
```

Resultado esperado:

```text
tipo_solicitud = documental
Output = 0
```

Estado:

```text
Aprobado
```

---

### Prueba 2 — Analítica dataset

Entrada:

```text
Muéstrame métricas del dataset
```

Resultado esperado:

```text
tipo_solicitud = analitica_dataset
Output = 1
```

Estado:

```text
Aprobado
```

---

### Prueba 3 — Reserva simulada

Entrada:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Resultado esperado:

```text
tipo_solicitud = reserva_simulada
Output = 2
```

Estado:

```text
Aprobado
```

---

### Prueba 4 — Fuera de alcance

Entrada:

```text
Cuéntame un chiste
```

Resultado esperado:

```text
tipo_solicitud = fuera_alcance
Output = 3
```

Estado:

```text
Aprobado
```

---

### Prueba 5 — Disponibilidad habitaciones

Entrada:

```text
¿Hay habitaciones familiares disponibles?
```

Resultado esperado:

```text
tipo_solicitud = disponibilidad_habitaciones
Output = 4
```

Estado:

```text
Aprobado
```

---

### Prueba 6 — Consultoría

Entrada:

```text
¿Qué habitación me recomiendas para viajar con mi familia?
```

Resultado esperado:

```text
tipo_solicitud = consultoria
Output = 5
```

Estado:

```text
Aprobado como clasificación.
Pendiente como módulo funcional propio.
```

---

### Prueba 7 — Memoria usuario

Entrada:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Resultado esperado:

```text
tipo_solicitud = memoria_usuario
Output = 6
```

Estado:

```text
Aprobado
```

---

## 5. Pruebas del módulo documental

### Prueba documental principal

Entrada:

```text
¿Cuáles son las políticas de cancelación del hotel?
```

Ruta esperada:

```text
HTTP Request
→ Code - Preparar Contexto Documental
→ AI Agent
→ Code - Formatear Salida Documental
```

Resultado esperado:

```text
El sistema responde usando la política de cancelación del documento base.
```

Resultado observado:

```text
El sistema respondió que las reservas pueden cancelarse sin penalización hasta 48 horas antes de la fecha de entrada, y que con menos de 48 horas puede cobrarse penalización equivalente a una noche.
```

Estado:

```text
Aprobado
```

---

## 6. Pruebas de optimización documental

### Objetivo

Verificar que el documento completo no se envíe directamente al agente sin procesamiento previo.

Nodo evaluado:

```text
Code - Preparar Contexto Documental
```

Campos esperados:

```text
contexto_documental
documento_crudo_chars
contexto_documental_chars
secciones_documentales_usadas
keywords_documentales_usadas
optimizacion_documental_activa
```

Resultado esperado:

```text
contexto_documental debe contener Markdown limpio, no JSON envuelto.
```

Estado:

```text
Aprobado
```

Observación:

```text
Se corrigió la lectura de documento_contenido para evitar que el contexto empezara con llaves JSON.
```

---

## 7. Pruebas de analítica

### Prueba analítica principal

Entrada:

```text
Muéstrame métricas del dataset
```

Ruta esperada:

```text
Postgres - Métricas Dataset
→ Code - Formatear Salida Analítica
```

Resultado esperado:

```text
Respuesta con métricas calculadas desde PostgreSQL.
```

Métricas esperadas:

- Total de reservas.
- Reservas canceladas.
- Tasa de cancelación.
- ADR promedio.
- Lead time promedio.

Estado:

```text
Aprobado
```

---

## 8. Pruebas de disponibilidad simple

### Prueba disponibilidad principal

Entrada:

```text
¿Hay habitaciones familiares disponibles?
```

Ruta esperada:

```text
Postgres - Disponibilidad Habitaciones
→ Code - Formatear Salida Disponibilidad
```

Resultado esperado:

```text
Respuesta con disponibilidad por tipo de habitación consultada desde PostgreSQL.
```

Estado:

```text
Aprobado
```

---

## 9. Pruebas de memoria personalizada

### Prueba memoria 1 — Nombre y preferencia

Entrada:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Ruta esperada:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
→ Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

Resultado esperado:

```text
nombre_usuario = Hector
preferencias_texto = habitaciones tranquilas
tipo_habitacion_preferida = null
vista_preferida = null
```

Estado:

```text
Aprobado
```

Observación:

```text
La IA llegó a proponer campos incorrectos como tipo_habitacion_preferida = sencilla y vista_preferida = tranquilas, pero el nodo Code - Validar Memoria Usuario JSON los descartó correctamente.
```

---

### Prueba memoria 2 — Adultos y niños

Entrada:

```text
Somos 2 adultos y 3 niños
```

Resultado esperado:

```text
numero_adultos = 2
numero_ninos = 3
```

Estado:

```text
Aprobado en pruebas previas.
```

---

### Prueba memoria 3 — Presupuesto y vista

Entrada:

```text
Mi presupuesto máximo es de 300000 por noche y prefiero vista al patio colonial
```

Resultado esperado:

```text
presupuesto_max_cop = 300000
vista_preferida = patio colonial
```

Estado:

```text
Aprobado en pruebas previas.
```

---

### Prueba memoria 4 — Habitación preferida

Entrada:

```text
Me gustaría que recuerdes que prefiero habitaciones dobles
```

Resultado esperado:

```text
tipo_habitacion_preferida = doble
```

Estado:

```text
Aprobado en pruebas previas.
```

---

## 10. Pruebas de reserva demo

### Prueba reserva explícita

Entrada:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Ruta esperada:

```text
Code - Extraer Datos Reserva
→ Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
→ If - ¿Reserva Completa?
→ Code - Validar Reserva Completa
→ Code - Preparar Consulta Reserva
→ Postgres - Buscar Habitación Disponible
→ If - ¿Hay disponibilidad?
→ If - ¿Cumple presupuesto?
→ Code - Preparar Registro Reserva
→ Postgres - Registrar Reserva Demo
→ Code - Confirmar Reserva Registrada
```

Resultado esperado:

```text
Reserva registrada si hay habitación disponible y cumple validaciones.
```

Estado:

```text
Aprobado en pruebas previas.
```

---

### Prueba reserva con habitación exacta no disponible

Entrada:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

Resultado esperado:

```text
El sistema respeta el código exacto y responde sin disponibilidad si la habitación no está disponible.
```

Estado:

```text
Aprobado en pruebas previas.
```

---

### Prueba reserva fuera de presupuesto

Entrada:

```text
Quiero reservar una habitación familiar para mañana por 2 noches con presupuesto de 300000
```

Resultado esperado:

```text
Si la habitación disponible supera el presupuesto, no se registra la reserva y se responde con Code - Fuera de Presupuesto.
```

Estado:

```text
Aprobado en pruebas previas.
```

---

## 11. Prueba de respuesta segura

Entrada:

```text
Cuéntame un chiste
```

Ruta esperada:

```text
Code - Respuesta Segura
```

Resultado esperado:

```text
El sistema responde que la solicitud está fuera del alcance del asistente hotelero.
```

Estado:

```text
Aprobado
```

---

## 12. Prueba de consultoría pendiente

Entrada:

```text
¿Qué habitación me recomiendas para viajar con mi familia?
```

Resultado esperado actual:

```text
tipo_solicitud = consultoria
```

Ruta actual:

```text
Code - Respuesta Segura
```

Estado:

```text
Clasificación aprobada.
Módulo de consultoría avanzada pendiente.
```

Observación:

```text
La intención consultoria ya existe y se clasifica correctamente, pero todavía no hay un módulo especializado que recomiende habitaciones.
```

---

## 13. Resumen de pruebas

| Módulo | Estado |
|---|---|
| Clasificación | Aprobado |
| Switch | Aprobado |
| Documental | Aprobado |
| Optimización documental | Aprobado |
| Analítica dataset | Aprobado |
| Disponibilidad simple | Aprobado |
| Reserva demo | Aprobado en pruebas previas |
| Memoria personalizada | Aprobado |
| Validación contra errores de IA | Aprobado |
| Respuesta segura | Aprobado |
| Consultoría | Clasificación aprobada, módulo pendiente |

---

## 14. Conclusión

El workflow actual pasó las pruebas principales de regresión.

Los módulos funcionales están operativos para una demostración académica.

El principal pendiente funcional sigue siendo:

```text
consultoría hotelera avanzada
```

El sistema actual no debe presentarse como producto final de producción, sino como prototipo académico avanzado con automatización, IA local, PostgreSQL, memoria personalizada y reserva demo inteligente.