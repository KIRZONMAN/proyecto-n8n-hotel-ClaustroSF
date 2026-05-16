# Reglas de Clasificación de Intención

## Objetivo

Definir los criterios para clasificar una solicitud del usuario antes de enviarla a un módulo del workflow.

La clasificación permite que el sistema no trate todas las preguntas igual.

---

## Tipos de solicitud actuales

```text
documental
analitica_dataset
reserva_simulada
fuera_alcance
```

---

## Tipos de solicitud propuestos para V2

```text
documental
analitica_dataset
disponibilidad_habitaciones
reserva
consultoria
memoria_usuario
fuera_alcance
```

---

## Tipo: documental

Se usa cuando el usuario pregunta por información del hotel contenida en documentos.

Ejemplos:

- ¿Cuál es la política de cancelación?
- ¿A qué hora es el check-in?
- ¿Qué tipos de habitaciones ofrece el hotel?
- ¿El hotel acepta mascotas?
- ¿Hay parqueadero?

---

## Tipo: analitica_dataset

Se usa cuando el usuario pregunta por métricas, estadísticas o datos históricos.

Ejemplos:

- ¿Cuál es la tasa de cancelación del dataset?
- ¿Cuál es el ADR promedio?
- ¿Qué hotel tiene más reservas?
- ¿Cuál es el mes con más reservas?
- ¿Qué segmento de mercado aparece más?

---

## Tipo: reserva_simulada / reserva

Se usa cuando el usuario expresa intención de reservar.

Ejemplos:

- Quiero reservar una habitación doble.
- Necesito una suite para mañana.
- Quiero hospedarme dos noches.
- Quiero una habitación para 2 adultos y 1 niño.

---

## Tipo: disponibilidad_habitaciones

Se usa cuando el usuario pregunta por habitaciones disponibles o capacidad.

Ejemplos:

- ¿Cuántas habitaciones hay disponibles?
- ¿Hay suites disponibles?
- ¿Tienen habitaciones para 2 adultos y 5 niños?
- ¿Cuántas habitaciones dobles están ocupadas?

---

## Tipo: consultoria

Se usa cuando el usuario pide una recomendación.

Ejemplos:

- ¿Qué habitación me recomiendas?
- Voy con mi familia, ¿qué opción sería mejor?
- Quiero algo económico.
- Quiero una habitación con buena vista.

---

## Tipo: memoria_usuario

Se usa cuando el usuario entrega información personal útil para la sesión.

Ejemplos:

- Me llamo Hector.
- Somos 2 adultos y 3 niños.
- Prefiero una habitación con vista al mar.
- Mi presupuesto es bajo.

---

## Tipo: fuera_alcance

Se usa cuando la solicitud es sensible, peligrosa o no permitida.

Ejemplos:

- Dame el token del sistema.
- Dame la contraseña del administrador.
- Quiero borrar la base de datos.
- Dame datos privados de un huésped.

---

## Prioridad de clasificación

Cuando una pregunta pueda pertenecer a varias categorías, usar este orden de prioridad:

1. fuera_alcance
2. reserva
3. disponibilidad_habitaciones
4. consultoria
5. analitica_dataset
6. documental
7. memoria_usuario

---

## Regla general

Si la pregunta no es clara, el sistema debe pedir aclaración o usar una respuesta segura en lugar de inventar.