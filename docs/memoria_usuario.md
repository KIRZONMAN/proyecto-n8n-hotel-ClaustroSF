# Memoria personalizada de usuario — Reception Agent ClaustroSF

## 1. Objetivo

La memoria personalizada permite que el asistente recuerde información útil del usuario durante una sesión.

Esta función busca que el asistente se comporte de forma más parecida a una recepción real, recordando preferencias y datos relevantes para futuras consultas o reservas.

---

## 2. Enfoque usado

La memoria se implementa con enfoque híbrido:

```text
IA interpreta → Code valida → PostgreSQL guarda
```

La IA ayuda a interpretar lenguaje natural.

El código valida que el JSON sea seguro y útil.

PostgreSQL guarda la información persistente por sesión.

---

## 3. Ruta de memoria

```text
Switch - Tipo de solicitud
Output memoria_usuario
→ AI Agent - Extraer Memoria Usuario JSON
→ Code - Validar Memoria Usuario JSON
→ If - ¿Memoria Válida?
   ├── false → Code - Memoria No Guardada
   └── true
       → Postgres - Guardar Memoria Usuario
       → Code - Confirmar Memoria Guardada
```

---

## 4. Tabla usada

```text
memoria_usuario_demo
```

Campos principales:

| Campo | Descripción |
|---|---|
| `session_id` | Identificador de sesión. |
| `nombre_usuario` | Nombre del usuario. |
| `numero_adultos` | Cantidad de adultos. |
| `numero_ninos` | Cantidad de niños. |
| `tipo_habitacion_preferida` | Tipo de habitación preferido. |
| `vista_preferida` | Vista preferida. |
| `presupuesto_max_cop` | Presupuesto máximo por noche. |
| `preferencias_texto` | Resumen de preferencias libres. |
| `ultima_pregunta` | Última frase procesada. |
| `created_at` | Fecha de creación. |
| `updated_at` | Última actualización. |

---

## 5. Datos que puede recordar

El sistema puede recordar:

```text
nombre del usuario
número de adultos
número de niños
tipo de habitación preferida
vista preferida
presupuesto máximo por noche
preferencias generales
```

Ejemplos:

```text
Me llamo Hector.
Somos 2 adultos y 3 niños.
Prefiero habitaciones tranquilas.
Mi presupuesto es de 300000 por noche.
Prefiero vista al patio colonial.
Prefiero una habitación familiar cómoda.
```

---

## 6. AI Agent de extracción de memoria

El nodo:

```text
AI Agent - Extraer Memoria Usuario JSON
```

recibe la frase del usuario y devuelve un JSON con campos como:

```json
{
  "memoria_detectada": true,
  "nombre_usuario": "Hector",
  "numero_adultos": 2,
  "numero_ninos": 3,
  "tipo_habitacion_preferida": "familiar",
  "vista_preferida": "patio colonial",
  "presupuesto_max_cop": 300000,
  "preferencias_texto": "Prefiere habitaciones tranquilas",
  "campos_detectados": [
    "nombre_usuario",
    "numero_adultos",
    "numero_ninos",
    "tipo_habitacion_preferida",
    "vista_preferida",
    "presupuesto_max_cop",
    "preferencias_texto"
  ],
  "confianza_extraccion": "alta"
}
```

---

## 7. Validación del JSON

El nodo:

```text
Code - Validar Memoria Usuario JSON
```

se encarga de:

- Limpiar salida del agente.
- Convertir texto a JSON.
- Recuperar campos aunque el JSON venga escapado.
- Validar tipos de datos.
- Normalizar valores.
- Preparar campos SQL.
- Marcar si la memoria es válida.

Campos importantes:

```text
memoria_json_valido
memoria_valida
memoria_detectada
campos_detectados
estado_validacion_memoria
```

---

## 8. Guardado en PostgreSQL

El nodo:

```text
Postgres - Guardar Memoria Usuario
```

usa un `UPSERT` por:

```text
session_id
```

Esto significa:

```text
si la sesión no existe → crea memoria
si la sesión existe → actualiza datos nuevos
```

La memoria no se duplica por cada frase, sino que se actualiza.

---

## 9. Confirmación al usuario

El nodo:

```text
Code - Confirmar Memoria Guardada
```

devuelve una respuesta amigable.

Ejemplo:

```text
Listo, guardé esta información en la memoria demo del asistente: tu nombre es Hector; Prefiere habitaciones tranquilas. La usaré como referencia en futuras consultas dentro de esta sesión académica.
```

---

## 10. Integración con reservas

La memoria se usa dentro de la rama de reservas mediante:

```text
Postgres - Consultar Memoria Usuario Reserva
→ Code - Aplicar Memoria a Reserva
```

Esto permite completar reservas incompletas.

Ejemplo:

Memoria:

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

Resultado:

```text
tipo_habitacion = familiar
numero_personas = 5
fecha_entrada = mañana
numero_noches = 2
vista_preferida = patio colonial
presupuesto_max_cop = 300000
```

---

## 11. Regla de prioridad

La memoria solo completa datos faltantes.

Si el usuario da información explícita en la pregunta actual, esa información gana.

Prioridad:

```text
1. Pregunta actual
2. Memoria guardada
3. Dato faltante
```

Ejemplo:

Memoria:

```text
tipo_habitacion_preferida = familiar
```

Pregunta actual:

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

Resultado:

```text
tipo_habitacion = doble
```

---

## 12. Manejo de habitación exacta

Si el usuario pide una habitación por código:

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

el sistema debe respetar el código.

La memoria no debe cambiar el tipo de habitación a familiar aunque la preferencia guardada sea familiar.

Regla:

```text
código exacto de habitación > memoria de tipo de habitación
```

---

## 13. Validación de presupuesto

La memoria puede guardar:

```text
presupuesto_max_cop
```

Este valor se usa para evitar registrar automáticamente habitaciones que excedan el presupuesto.

Si la habitación cuesta más que el presupuesto:

```text
Code - Fuera de Presupuesto
```

Si cumple:

```text
Postgres - Registrar Reserva Demo
```

---

## 14. Pruebas usadas

### Guardar nombre

```text
Me llamo Hector y prefiero habitaciones tranquilas
```

### Guardar grupo

```text
Somos 2 adultos y 3 niños
```

### Guardar presupuesto y vista

```text
Mi presupuesto es de 300000 por noche y prefiero vista al patio colonial
```

### Guardar tipo de habitación

```text
Prefiero una habitación familiar cómoda
```

### Usar memoria en reserva

```text
Quiero reservar para mañana por 2 noches
```

### Datos explícitos ganan

```text
Quiero reservar una habitación doble para 2 personas por 2 noches mañana
```

### Presupuesto explícito gana

```text
Quiero reservar una habitación familiar para mañana por 2 noches con presupuesto de 350000
```

### Habitación exacta

```text
Quiero reservar la habitación D-007 para 2 personas por 2 noches mañana
```

---

## 15. Limitaciones de la memoria

- Funciona por `session_id`, no por autenticación real.
- Si se reutiliza el mismo `session_id`, se reutiliza la misma memoria.
- `preferencias_texto` puede crecer con muchas preferencias.
- No existe aún un módulo para borrar preferencias desde conversación.
- No hay expiración automática de memoria.
- No hay perfiles de usuario reales.

---

## 16. Mejoras futuras

- Añadir comando para borrar memoria.
- Separar preferencias en tabla relacional.
- Crear historial de cambios de memoria.
- Implementar memoria por usuario autenticado.
- Compactar preferencias repetidas.
- Usar memoria en consultoría hotelera avanzada.
- Usar memoria con Telegram o frontend externo.

---

## 17. Conclusión

La memoria personalizada quedó funcional.

El sistema puede:

```text
interpretar preferencias con IA
validar JSON
guardar memoria en PostgreSQL
actualizar memoria por sesión
usar memoria para completar reservas
respetar datos explícitos del usuario
validar presupuesto y disponibilidad
```

Esta fase mejora considerablemente el comportamiento del asistente, porque ya no responde solo a preguntas aisladas, sino que puede usar contexto guardado para actuar de forma más personalizada.