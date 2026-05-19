# Riesgos y limitaciones — Reception Agent ClaustroSF

## 1. Descripción general

Este documento identifica riesgos, limitaciones y mejoras pendientes del proyecto **Reception Agent ClaustroSF**.

El sistema es un prototipo académico construido con n8n, PostgreSQL y Ollama. Aunque tiene una lógica funcional avanzada, no debe interpretarse como un sistema productivo listo para operar en un hotel real.

---

## 2. Limitaciones funcionales

### 2.1 Reserva demo

Las reservas son simuladas.

Aunque el sistema registra datos en PostgreSQL, no existe una operación real con:

- Pagos.
- Confirmación legal.
- Contratos.
- Facturación.
- Validación documental.
- Identidad real del huésped.

---

### 2.2 Disponibilidad por estado general

La disponibilidad se basa en el campo:

```text
estado
```

de la tabla:

```text
habitaciones_demo
```

Esto permite saber si una habitación está:

```text
disponible
reservada
ocupada
mantenimiento
```

Pero todavía no maneja disponibilidad por fecha real.

Ejemplo de limitación:

```text
Una habitación puede estar reservada para mañana, pero disponible la próxima semana.
```

El sistema actual no calcula ese calendario.

---

### 2.3 Fechas relativas

El sistema puede manejar expresiones como:

```text
mañana
hoy
```

pero todavía puede conservarlas como texto.

No existe aún una conversión completa a fecha real tipo:

```text
YYYY-MM-DD
```

---

### 2.4 Memoria por sesión

La memoria se guarda por:

```text
session_id
```

No hay autenticación real de usuarios.

Esto significa que si varias personas usan el mismo `session_id`, podrían compartir memoria.

---

### 2.5 Preferencias acumuladas

El campo:

```text
preferencias_texto
```

puede crecer si el usuario guarda muchas preferencias.

Ejemplo:

```text
Prefiere habitaciones tranquilas | Prefiere habitación familiar cómoda | Prefiere vista al patio colonial
```

Esto es funcional para demo, pero en producción debería normalizarse mejor.

---

### 2.6 Consultoría avanzada pendiente

El módulo de consultoría hotelera todavía no está completamente desarrollado.

Actualmente el sistema puede guardar preferencias y usarlas en reservas, pero falta una rama más completa para responder preguntas como:

```text
Somos 2 adultos y 3 niños, ¿qué habitación nos recomiendas?
```

con razonamiento más elaborado.

---

## 3. Limitaciones técnicas

### 3.1 Rendimiento de Ollama

El uso de Ollama local puede tardar dependiendo de:

- Modelo usado.
- Capacidad de CPU/GPU.
- Memoria disponible.
- Tamaño del prompt.
- Carga del equipo.

Las rutas con IA son más lentas que las rutas puramente SQL o Code.

---

### 3.2 Dependencia del formato JSON de la IA

El extractor de memoria depende de que el modelo devuelva un JSON interpretable.

Para reducir el riesgo, se implementó:

```text
Code - Validar Memoria Usuario JSON
```

Este nodo limpia, valida y normaliza la salida antes de guardar.

---

### 3.3 n8n como prototipo

n8n es útil para prototipos y automatización, pero un sistema productivo requeriría considerar:

- Control de versiones más estricto.
- Separación de ambientes.
- Monitoreo.
- Manejo de errores avanzado.
- Seguridad de credenciales.
- Pruebas automatizadas.
- Logs persistentes.

---

### 3.4 SQL embebido en nodos

Actualmente varias consultas SQL están dentro de nodos de n8n.

Esto funciona para la demo, pero a futuro podría ser mejor separar:

```text
scripts SQL
vistas
funciones almacenadas
procedimientos
```

para mejorar mantenibilidad.

---

### 3.5 Falta de pruebas automatizadas

Las pruebas se han ejecutado manualmente desde n8n.

Falta implementar pruebas automatizadas para verificar:

- Clasificación de intención.
- Memoria guardada.
- Reservas registradas.
- Casos fuera de presupuesto.
- Casos sin disponibilidad.
- No duplicidad de reservas.

---

## 4. Riesgos de seguridad

### 4.1 Información sensible

El asistente debe rechazar solicitudes relacionadas con:

- Contraseñas.
- Tokens.
- Credenciales.
- Cuentas bancarias internas.
- Información privada.
- Accesos administrativos.

Para esto existe la ruta:

```text
fuera_alcance
```

y el nodo:

```text
Code - Respuesta Segura
```

---

### 4.2 Inyección en texto

Como el sistema recibe texto libre del usuario, existe riesgo de entradas maliciosas.

Se mitiga parcialmente mediante:

```text
sqlText()
normalización de texto
validación de campos
uso de valores permitidos
```

Sin embargo, para producción se recomienda usar consultas parametrizadas siempre que sea posible.

---

### 4.3 Memoria no autenticada

La memoria depende del `session_id`.

Si el `session_id` se reutiliza de forma incorrecta, se puede mezclar información de usuarios.

En un sistema real se necesitaría autenticación y control de sesiones.

---

## 5. Riesgos de negocio

### 5.1 Confirmación automática

Registrar reservas automáticamente puede ser riesgoso si no existe confirmación final del huésped.

El sistema ya evita registrar cuando supera presupuesto, pero a futuro podría pedir confirmación explícita antes de cualquier registro.

Ejemplo futuro:

```text
Encontré esta habitación. ¿Confirmas la reserva?
```

---

### 5.2 Precios y disponibilidad simulados

Los precios y habitaciones son datos demo.

No representan inventario real de un hotel.

---

### 5.3 Expectativas del usuario

El usuario podría creer que la reserva es real.

Por eso las respuestas deben aclarar que es un entorno académico/demo.

---

## 6. Limitaciones de IA

### 6.1 Posibles errores de interpretación

La IA puede interpretar mal frases ambiguas.

Ejemplo:

```text
Quiero algo tranquilo, pero barato.
```

Puede haber dudas sobre si es memoria, consultoría o reserva.

Para reducir esto se usa:

```text
clasificación por reglas
validación por código
rutas controladas
```

---

### 6.2 Variabilidad del modelo

Aunque se use baja temperatura, el modelo puede variar un poco sus respuestas.

Por eso no se permite que la IA:

```text
ejecute SQL
registre reservas
cambie estados de habitaciones
decida directamente operaciones críticas
```

La IA solo interpreta texto.

---

## 7. Limitaciones del módulo de reserva

### 7.1 Disponibilidad por habitación, no por calendario

El sistema valida si una habitación está disponible en general, no si está disponible durante un rango de fechas.

### 7.2 No hay cancelación real

Existe reset de reservas demo, pero no un módulo conversacional completo para cancelar una reserva.

### 7.3 No hay pagos

No se integra ningún método de pago.

### 7.4 No hay datos personales completos

No se solicitan datos como:

- Documento.
- Correo.
- Teléfono.
- País.
- Método de pago.

Esto es intencional para mantener el proyecto académico.

---

## 8. Riesgos de mantenimiento

### 8.1 Workflow grande

A medida que el workflow crece, puede ser más difícil de mantener visualmente.

Recomendación futura:

```text
Separar subworkflows
documentar nodos
usar nombres consistentes
eliminar nodos flotantes
```

---

### 8.2 Repetición de lógica

Algunos nodos Code pueden repetir funciones de normalización.

A futuro se podría centralizar esa lógica en scripts o subworkflows.

---

## 9. Mejoras futuras

### 9.1 Optimización de rendimiento

- Reducir prompts.
- Usar IA solo cuando sea necesario.
- Mantener reglas para casos simples.
- Evitar llamadas duplicadas al modelo.

### 9.2 pgvector / RAG documental

Implementar búsqueda semántica con pgvector para mejorar respuestas documentales.

### 9.3 Consultoría hotelera avanzada

Crear un módulo que recomiende habitaciones según:

- Adultos.
- Niños.
- Presupuesto.
- Vista.
- Preferencias.
- Disponibilidad.
- Propósito del viaje.

### 9.4 Integración con Telegram

Permitir interacción desde un canal más cómodo.

### 9.5 Frontend web

Crear una interfaz para simular un chat de recepción.

### 9.6 Fechas reales

Convertir expresiones como `mañana` a fechas reales.

### 9.7 Disponibilidad por rango de fechas

Crear una tabla de ocupación por fechas para validar disponibilidad real.

---

## 10. Conclusión

El sistema actual es suficientemente sólido para una demostración académica avanzada.

Ya integra:

```text
IA local
memoria personalizada
PostgreSQL
disponibilidad
reservas demo
validación de presupuesto
manejo de errores
```

Sus principales limitaciones están relacionadas con uso productivo real: autenticación, calendario, pagos, seguridad avanzada y escalabilidad.

Para la entrega, estas limitaciones pueden presentarse como oportunidades de mejora.