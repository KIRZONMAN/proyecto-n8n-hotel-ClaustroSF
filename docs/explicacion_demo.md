# Explicación para demo — Reception Agent ClaustroSF

## 1. Presentación breve del proyecto

Reception Agent ClaustroSF es un asistente hotelero académico desarrollado en n8n.

El sistema simula una recepción inteligente para el Hotel El Claustro de San Francisco. Puede responder preguntas sobre el hotel, consultar datos históricos, revisar disponibilidad, recordar preferencias del usuario y registrar reservas demo en PostgreSQL.

---

## 2. Problema que aborda

En un hotel, muchas tareas de recepción son repetitivas:

- Responder preguntas sobre políticas.
- Consultar disponibilidad.
- Revisar tipos de habitación.
- Recordar preferencias del huésped.
- Estimar costos.
- Registrar reservas.
- Rechazar solicitudes que no se pueden cumplir.

Este proyecto automatiza parte de ese proceso mediante un flujo en n8n conectado a IA local y PostgreSQL.

---

## 3. Valor agregado

El sistema no solo responde texto. También:

- Clasifica la intención del usuario.
- Decide qué rama ejecutar.
- Usa IA para interpretar preferencias.
- Guarda memoria personalizada.
- Consulta base de datos.
- Valida reglas de negocio.
- Registra reservas demo.
- Rechaza casos inválidos de forma controlada.

---

## 4. Arquitectura resumida

El workflow empieza con:

```text
Edit Fields
→ Code - Normalizar Pregunta
→ Code - Clasificar Intención
→ Switch - Tipo de solicitud
```

Después, según la intención, puede ir a:

```text
documental
analítica
disponibilidad
memoria
reserva
respuesta segura
```

---

## 5. Explicación de la memoria personalizada

La memoria personalizada permite que el sistema recuerde datos del usuario durante la sesión.

Ejemplos:

```text
Me llamo Hector.
Somos 2 adultos y 3 niños.
Prefiero habitaciones tranquilas.
Mi presupuesto es de 300000 por noche.
Prefiero vista al patio colonial.
```

Estos datos se guardan en PostgreSQL, en la tabla:

```text
memoria_usuario_demo
```

La ruta es:

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

La IA interpreta el texto, pero el código valida el JSON antes de guardar.

---

## 6. Explicación de la reserva inteligente

La reserva inteligente permite que el usuario no tenga que repetir toda la información.

Si el usuario ya guardó memoria:

```text
2 adultos
3 niños
habitación familiar
vista al patio colonial
presupuesto máximo 300000
```

luego puede escribir:

```text
Quiero reservar para mañana por 2 noches.
```

El sistema completa los datos faltantes desde memoria.

---

## 7. Regla importante: la pregunta actual manda

La memoria no reemplaza lo que el usuario acaba de escribir.

Si la memoria dice:

```text
habitación familiar
```

pero el usuario pregunta:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

el sistema usa:

```text
habitación doble
2 personas
```

Esto evita que la memoria cause errores.

---

## 8. Validación de disponibilidad

El sistema consulta la tabla:

```text
habitaciones_demo
```

Y revisa:

```text
tipo de habitación
estado
capacidad
código de habitación
```

Si la habitación está disponible, continúa.

Si no está disponible, responde con:

```text
Code - Sin Disponibilidad
```

---

## 9. Validación de presupuesto

Antes de registrar la reserva, el sistema revisa:

```text
precio_noche_cop <= presupuesto_max_cop
```

Si el precio cumple, registra.

Si el precio supera el presupuesto, no registra automáticamente y responde con:

```text
Code - Fuera de Presupuesto
```

Esto evita confirmar una reserva que excede el presupuesto del usuario.

---

## 10. Pruebas recomendadas para la presentación

### Prueba 1 — Guardar nombre

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Qué demuestra:

```text
La IA interpreta memoria y PostgreSQL la guarda.
```

---

### Prueba 2 — Guardar grupo familiar

```text
Somos 2 adultos y 3 niños
```

Qué demuestra:

```text
El sistema recuerda cantidad de personas.
```

---

### Prueba 3 — Guardar presupuesto y vista

```text
Mi presupuesto es de 300000 por noche y prefiero vista al patio colonial
```

Qué demuestra:

```text
El sistema recuerda preferencias útiles para reservas.
```

---

### Prueba 4 — Guardar tipo de habitación

```text
Prefiero una habitación familiar cómoda
```

Qué demuestra:

```text
El sistema recuerda tipo de habitación preferida.
```

---

### Prueba 5 — Reserva incompleta usando memoria

```text
Quiero reservar para mañana por 2 noches
```

Qué demuestra:

```text
El sistema usa memoria para completar tipo de habitación y número de personas.
```

---

### Prueba 6 — Fuera de presupuesto

```text
Quiero reservar una habitación familiar para mañana por 2 noches con presupuesto de 300000
```

Qué demuestra:

```text
El sistema encuentra habitación, pero no la registra si supera el presupuesto.
```

---

### Prueba 7 — Reserva explícita

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Qué demuestra:

```text
Los datos explícitos del usuario tienen prioridad sobre la memoria.
```

---

### Prueba 8 — Habitación exacta no disponible

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

Qué demuestra:

```text
El sistema respeta el código exacto y rechaza si no está disponible.
```

---

### Prueba 9 — Consulta documental

```text
¿Cuál es la política de cancelación?
```

Qué demuestra:

```text
Consulta documental con IA local y GitHub RAW.
```

---

### Prueba 10 — Analítica

```text
¿Cuál es la tasa de cancelación del dataset?
```

Qué demuestra:

```text
Consulta SQL sobre dataset histórico.
```

---

## 11. Guion corto de explicación

Este workflow funciona como un asistente hotelero inteligente. Primero recibe una pregunta del usuario, la normaliza y clasifica su intención. Según la intención, el sistema decide si debe consultar documentación, analizar datos, revisar disponibilidad, guardar memoria o procesar una reserva.

La parte más importante de esta versión es la memoria personalizada. El asistente puede recordar datos como el nombre del usuario, número de adultos, número de niños, tipo de habitación preferida, vista preferida y presupuesto máximo. Esa memoria se guarda en PostgreSQL.

Cuando el usuario hace una reserva incompleta, el sistema consulta esa memoria y completa los datos faltantes. Sin embargo, los datos explícitos de la pregunta actual siempre tienen prioridad sobre la memoria. Luego el sistema consulta disponibilidad, valida capacidad, revisa presupuesto y solo registra la reserva si cumple las condiciones.

---

## 12. Qué decir si algo tarda

Como el proyecto usa Ollama local, algunas respuestas con IA pueden tardar más que una llamada puramente SQL. Esto es normal porque el modelo se ejecuta en la máquina local.

Se puede explicar así:

```text
Las rutas que no usan IA, como disponibilidad o consulta SQL, responden más rápido. Las rutas donde el modelo interpreta memoria pueden tardar un poco más porque Ollama procesa el lenguaje natural localmente.
```

---

## 13. Qué decir si una habitación aparece no disponible

Se puede explicar así:

```text
El sistema actualiza el estado de las habitaciones cuando registra una reserva. Por eso, si una habitación ya fue usada en una prueba anterior, puede aparecer como reservada o no disponible. Esto demuestra que la base de datos conserva el estado operacional.
```

---

## 14. Cierre de la demo

Para cerrar, se puede decir:

```text
Este prototipo demuestra cómo n8n puede orquestar IA local, PostgreSQL, memoria personalizada y reglas de negocio para simular una recepción hotelera inteligente. Aunque es un entorno académico, ya incluye lógica realista de disponibilidad, presupuesto, memoria y manejo de errores.
```