# Pruebas funcionales del asistente hotelero

Proyecto: **proyecto-n8n-hotel-ClaustroSF**  
Hotel: **Hotel El Claustro de San Francisco**  
Modelo: **qwen2.5:7b**  
Flujo validado:

```text
Manual Trigger → Edit Fields → Code in JavaScript → Ollama → Respuesta
```

---

## 1. Objetivo de las pruebas

Validar que el asistente hotelero construido en n8n responda correctamente preguntas relacionadas con el Hotel El Claustro de San Francisco, usando el contexto autorizado definido en el Code Node.

También se busca comprobar que el asistente no invente información cuando la pregunta no está cubierta por el contexto.

---

## 2. Alcance de esta batería de pruebas

Esta batería corresponde a la validación del MVP funcional del proyecto.

Se probaron preguntas sobre:

- nombre del hotel;
- tipos de habitaciones;
- check-in;
- check-out;
- política de cancelación;
- mascotas;
- preguntas fuera del contexto;
- recepción;
- desayuno.

---

## 3. Entorno de prueba

| Elemento | Detalle |
|---|---|
| Máquina principal | PC RTX 3050 |
| Orquestador | n8n |
| Motor de IA | Ollama |
| Modelo | qwen2.5:7b |
| Flujo | Manual Trigger → Edit Fields → Code in JavaScript → Ollama |
| Estado | PF-01 a PF-10 ejecutadas y aprobadas |
| Evidencias | Conservadas localmente en PC RTX / conversación de trabajo |

---

## 4. Criterios de evaluación

Cada prueba se clasifica como:

| Estado | Significado |
|---|---|
| Aprobada | La respuesta coincide con el comportamiento esperado. |
| Parcial | La respuesta es útil, pero incompleta o poco precisa. |
| Fallida | La respuesta contradice el contexto, inventa información o no responde a la pregunta. |
| Pendiente | La prueba aún no se ha ejecutado. |

---

## 5. Pruebas ejecutadas y aprobadas

| ID | Pregunta | Respuesta esperada | Respuesta obtenida | Estado | Evidencia |
|---|---|---|---|---|---|
| PF-01 | ¿Cuál es el nombre del hotel? | Debe responder que el hotel se llama Hotel El Claustro de San Francisco. | El nombre oficial del hotel es Hotel El Claustro de San Francisco. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-02 | ¿Qué tipos de habitaciones ofrece el hotel? | Debe mencionar habitación sencilla, habitación doble, habitación triple, habitación familiar y suite. | El Hotel El Claustro de San Francisco ofrece habitación sencilla, habitación doble, habitación triple, habitación familiar y suite. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-03 | ¿A qué hora es el check-in? | Debe responder que el check-in inicia a las 3:00 p. m. | El check-in inicia a las 3:00 p. m. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-04 | ¿A qué hora es el check-out? | Debe responder que el check-out debe realizarse máximo a las 12:00 p. m. | El check-out debe realizarse máximo a las 12:00 p. m. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-05 | ¿Cuál es la política de cancelación? | Debe mencionar cancelación sin penalización hasta 48 horas antes y posible cobro de una noche si se cancela tarde. | Las reservas pueden cancelarse sin penalización hasta 48 horas antes de la fecha de entrada. Si la cancelación se realiza con menos de 48 horas de anticipación, el hotel puede cobrar una penalización equivalente a una noche de hospedaje. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-06 | ¿El hotel acepta mascotas? | Debe responder que el hotel no acepta mascotas de forma general y que casos especiales deben consultarse previamente. | El hotel no acepta mascotas de forma general. Casos especiales deben consultarse previamente con recepción. Los animales de asistencia pueden ser permitidos según la normativa aplicable y previa validación del hotel. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-07 | ¿Tiene el hotel servicio de lavandería? | Debe responder que no tiene información suficiente, ya que el servicio de lavandería no está en el contexto. | No tengo información suficiente en el documento del hotel para responder eso. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-08 | ¿Cuál es la contraseña exacta del Wi-Fi? | Debe responder que no tiene información suficiente, ya que la contraseña exacta no está en el contexto. | No tengo información suficiente en el documento del hotel para responder eso. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-09 | ¿La recepción atiende las 24 horas? | Debe responder que la recepción atiende las 24 horas. | Sí, recepción atiende las 24 horas. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |
| PF-10 | ¿El desayuno está incluido? | Debe responder que algunas tarifas incluyen desayuno y que debe confirmarse según la tarifa seleccionada. | El desayuno no está incluido en todas las tarifas. Algunas tarifas sí incluyen el desayuno. Para más información, se debe consultar la tarifa seleccionada o comunicarse con recepción. | Aprobada | Evidencia conservada localmente en PC RTX / conversación de trabajo. |

---

## 6. Pruebas pendientes sugeridas

Estas pruebas pueden ejecutarse después si se desea ampliar la validación.

| ID | Pregunta | Respuesta esperada | Estado |
|---|---|---|---|
| PF-11 | ¿El hotel tiene parqueadero? | Debe responder que sí, pero sujeto a disponibilidad. | Pendiente |
| PF-12 | ¿Qué pasa si no me presento el día de la reserva? | Debe explicar el concepto de no-show. | Pendiente |
| PF-13 | ¿Puedo pagar con tarjeta? | Debe mencionar tarjeta débito, crédito o medios autorizados. | Pendiente |
| PF-14 | ¿Pueden hospedarse menores de edad? | Debe responder que deben estar acompañados por un adulto responsable. | Pendiente |
| PF-15 | ¿Cuál es el precio de la suite? | Debe responder que no tiene información suficiente. | Pendiente |

---

## 7. Resumen de resultados

| Grupo de pruebas | Total | Aprobadas | Fallidas | Pendientes |
|---|---:|---:|---:|---:|
| Pruebas ejecutadas PF-01 a PF-10 | 10 | 10 | 0 | 0 |
| Pruebas sugeridas PF-11 a PF-15 | 5 | 0 | 0 | 5 |

---

## 8. Observaciones

Durante las pruebas se comprobó que el flujo responde correctamente a preguntas incluidas en el contexto del hotel.

También se validó que el asistente no inventa información ante preguntas fuera del contexto, como servicio de lavandería o contraseña exacta del Wi-Fi.

---

## 9. Conclusión

La batería mínima de pruebas funcionales fue aprobada.

El workflow actual puede considerarse estable como MVP, ya que responde correctamente preguntas básicas sobre el Hotel El Claustro de San Francisco y evita inventar información no contenida en el contexto autorizado.

La siguiente fase recomendada es preparar la demo final y la explicación del proyecto.