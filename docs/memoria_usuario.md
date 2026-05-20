# Memoria personalizada de usuario

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

El módulo de memoria personalizada permite guardar datos útiles del usuario para reutilizarlos en futuras reservas o interacciones dentro de la misma sesión.

La memoria hace que el asistente no responda cada pregunta como si fuera aislada, sino que pueda recordar información relevante.

---

## 2. Enfoque del módulo

La memoria se implementa con el siguiente enfoque:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

Esto significa:

- La IA interpreta el mensaje del usuario.
- El nodo Code valida y limpia la salida.
- PostgreSQL guarda solo los datos aceptados.

La IA no guarda directamente en la base de datos.

---

## 3. Ruta del módulo

```text
AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
```

Si la memoria no es válida:

```text
Code - Memoria No Guardada
```

Si la memoria es válida:

```text
Postgres - Guardar Memoria Usuario
→ Code - Confirmar Memoria Guardada
```

---

## 4. Datos que puede guardar

El sistema puede guardar:

| Campo | Descripción |
|---|---|
| `nombre_usuario` | Nombre declarado por el usuario. |
| `numero_adultos` | Cantidad de adultos. |
| `numero_ninos` | Cantidad de niños. |
| `tipo_habitacion_preferida` | Tipo de habitación preferido. |
| `vista_preferida` | Vista preferida. |
| `presupuesto_max_cop` | Presupuesto máximo por noche. |
| `preferencias_texto` | Preferencias generales del usuario. |

---

## 5. Tabla usada

La memoria se almacena en PostgreSQL en la tabla:

```text
memoria_usuario_demo
```

La clave funcional es:

```text
session_id
```

Esto permite que cada sesión mantenga su memoria propia.

---

## 6. Ejemplos de memoria válida

### Nombre y preferencias

Entrada:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

Datos esperados:

```text
nombre_usuario = Hector
preferencias_texto = habitaciones tranquilas
```

---

### Grupo familiar

Entrada:

```text
Somos 2 adultos y 3 niños
```

Datos esperados:

```text
numero_adultos = 2
numero_ninos = 3
```

---

### Presupuesto y vista

Entrada:

```text
Mi presupuesto máximo es de 300000 por noche y prefiero vista al patio colonial
```

Datos esperados:

```text
presupuesto_max_cop = 300000
vista_preferida = patio colonial
```

---

### Tipo de habitación

Entrada:

```text
Me gustaría que recuerdes que prefiero habitaciones dobles
```

Datos esperados:

```text
tipo_habitacion_preferida = doble
```

---

## 7. AI Agent de memoria

El nodo:

```text
AI Agent - Extraer Memoria Usuario JSON
```

toma el mensaje del usuario y devuelve un JSON.

Ejemplo esperado:

```json
{
  "memoria_detectada": true,
  "nombre_usuario": "Hector",
  "numero_adultos": null,
  "numero_ninos": null,
  "tipo_habitacion_preferida": null,
  "vista_preferida": null,
  "presupuesto_max_cop": null,
  "preferencias_texto": "habitaciones tranquilas",
  "campos_detectados": ["nombre_usuario", "preferencias_texto"],
  "confianza_extraccion": "alta"
}
```

---

## 8. Problema controlado: la IA puede equivocarse

El modelo puede interpretar mal algunas frases.

Ejemplo:

Entrada:

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

La IA podría proponer incorrectamente:

```json
{
  "tipo_habitacion_preferida": "sencilla",
  "vista_preferida": "tranquilas"
}
```

Esto es incorrecto porque:

```text
"habitaciones tranquilas" no significa habitación sencilla.
"tranquilas" no es una vista.
```

Por eso existe el nodo de validación.

---

## 9. Nodo de validación

El nodo:

```text
Code - Validar Memoria Usuario JSON
```

cumple una función crítica.

Se encarga de:

- Leer la salida del agente.
- Parsear el JSON.
- Normalizar valores.
- Validar campos permitidos.
- Convertir números.
- Limpiar presupuesto.
- Validar tipos de habitación.
- Validar vistas.
- Descartar falsos positivos.
- Preparar campos SQL.

---

## 10. Campos descartados

Cuando la IA propone información dudosa, el validador puede descartarla.

Ejemplo:

```json
"campos_descartados_memoria": [
  {
    "campo": "tipo_habitacion_preferida",
    "valor_original": "sencilla"
  },
  {
    "campo": "vista_preferida",
    "valor_original": "tranquilas"
  }
]
```

Esto demuestra que el sistema no confía ciegamente en la IA.

---

## 11. Memoria válida

Una memoria se considera válida si:

- El JSON pudo interpretarse.
- Existe al menos un dato útil.
- Los campos detectados son aceptables.
- Los campos no son ambiguos o inventados.
- La pregunta del usuario contiene señales reales de memoria.

Campo principal:

```text
memoria_valida = true
```

---

## 12. Memoria inválida

La memoria se considera inválida cuando:

- El JSON no se pudo parsear.
- No hay datos útiles.
- La IA inventó campos.
- La solicitud no contiene información reutilizable.
- Los campos detectados no pasan validación.

En este caso el flujo va a:

```text
Code - Memoria No Guardada
```

---

## 13. Guardado en PostgreSQL

El nodo:

```text
Postgres - Guardar Memoria Usuario
```

guarda o actualiza memoria en:

```text
memoria_usuario_demo
```

La memoria funciona con actualización por `session_id`.

Esto permite que el usuario pueda agregar información progresivamente.

Ejemplo:

Primero:

```text
Me llamo Hector
```

Después:

```text
Somos 2 adultos y 3 niños
```

Después:

```text
Mi presupuesto máximo es de 300000
```

El sistema puede ir completando la misma fila de memoria.

---

## 14. Limpieza de memoria de prueba

Durante pruebas, si la memoria se contamina con datos antiguos, se puede limpiar con:

```sql
DELETE FROM memoria_usuario_demo
WHERE session_id = 'demo-claustrosf';
```

Esto permite reiniciar la memoria demo de una sesión.

---

## 15. Uso de memoria en reservas

La memoria se usa también en la rama de reservas.

Ruta:

```text
Postgres - Consultar Memoria Usuario
→ Code - Aplicar Memoria a Reserva
```

Ejemplo:

Memoria guardada:

```text
numero_adultos = 2
numero_ninos = 3
tipo_habitacion_preferida = familiar
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

Pregunta:

```text
Quiero reservar para mañana por 2 noches
```

El sistema puede completar:

```text
numero_personas = 5
tipo_habitacion = familiar
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

---

## 16. Regla de prioridad

La memoria no debe reemplazar datos explícitos de la pregunta actual.

Prioridad:

```text
Pregunta actual > Memoria guardada > Dato faltante
```

Ejemplo:

Memoria:

```text
tipo_habitacion_preferida = familiar
```

Pregunta:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Resultado:

```text
tipo_habitacion = doble
```

---

## 17. Validación de presupuesto con memoria

Si el usuario guardó:

```text
presupuesto_max_cop = 300000
```

y luego hace una reserva incompleta, el sistema puede usar ese presupuesto para validar si la habitación encontrada lo supera.

Si supera presupuesto:

```text
Code - Fuera de Presupuesto
```

Si cumple presupuesto:

```text
Postgres - Registrar Reserva Demo
```

---

## 18. Riesgos controlados

Riesgos del módulo:

- La IA puede inventar campos.
- La IA puede interpretar preferencias como vistas.
- La IA puede convertir frases genéricas en tipos de habitación.
- La memoria puede acumular datos viejos si no se limpia en pruebas.
- El `session_id` demo puede mezclar pruebas diferentes.

Mitigaciones:

- Validación con Code.
- Campos descartados.
- Limpieza de memoria por SQL.
- Reglas de prioridad.
- Confirmación de memoria guardada.

---

## 19. Pruebas realizadas

Pruebas principales:

```text
Me llamo Hector y prefiero habitaciones tranquilas
Somos 2 adultos y 3 niños
Mi presupuesto máximo es de 300000 por noche y prefiero vista al patio colonial
Me gustaría que recuerdes que prefiero habitaciones dobles
```

Resultado general:

```text
El módulo funciona y descarta campos erróneos antes de guardar.
```

---

## 20. Estado actual

Estado del módulo:

```text
Funcional
```

Pendientes:

- Mejorar aún más el prompt del agente si fuera necesario.
- Permitir borrar memoria desde conversación.
- Separar preferencias en una tabla más estructurada.
- Crear memoria por usuario autenticado en vez de solo `session_id`.
- Usar memoria en consultoría hotelera futura.

---

## 21. Conclusión

La memoria personalizada quedó implementada de forma segura para un prototipo académico.

El punto más importante es que la IA no tiene autoridad final sobre la base de datos.

El sistema usa:

```text
AI Agent → Code de validación → PostgreSQL
```

Esto permite aprovechar interpretación de lenguaje natural sin perder control sobre los datos guardados.