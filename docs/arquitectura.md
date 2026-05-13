# Arquitectura del sistema

Proyecto: **proyecto-n8n-hotel-ClaustroSF**  
Hotel: **Hotel El Claustro de San Francisco**  
Modelo local: **qwen2.5:7b**  
Orquestador: **n8n**  
Motor de IA local: **Ollama**

---

## 1. Objetivo de la arquitectura

La arquitectura del proyecto busca construir un asistente hotelero básico capaz de responder preguntas relacionadas con el Hotel El Claustro de San Francisco usando n8n como herramienta de automatización y Ollama como motor local de lenguaje.

El sistema permite enviar una pregunta, construir un prompt con contexto del hotel, consultar el modelo local y devolver una respuesta estructurada.

---

## 2. Arquitectura funcional actual

El flujo funcional actual es:

```text
Manual Trigger
→ Edit Fields
→ Code in JavaScript
→ Ollama / qwen2.5:7b
→ Respuesta del asistente
```

---

## 3. Componentes principales

### 3.1 Docker Compose

Docker Compose se utiliza para levantar los servicios necesarios del proyecto:

- n8n;
- Ollama.

El archivo principal es:

```text
docker-compose.yml
```

---

### 3.2 n8n

n8n es la herramienta encargada de orquestar el flujo.

En el MVP actual se usa para:

- ejecutar manualmente el workflow;
- definir la pregunta del usuario;
- ejecutar código JavaScript;
- enviar la consulta al modelo local;
- recibir la respuesta de Ollama.

---

### 3.3 Ollama

Ollama funciona como servidor local de modelos de lenguaje.

El endpoint usado por el flujo es:

```text
http://ollama:11434/api/generate
```

Dentro de Docker, n8n se comunica con Ollama usando el nombre del servicio:

```text
ollama
```

Por eso se usa:

```text
http://ollama:11434
```

y no:

```text
http://localhost:11434
```

---

### 3.4 Modelo qwen2.5:7b

El modelo utilizado actualmente es:

```text
qwen2.5:7b
```

Este modelo responde a las preguntas del usuario usando el contexto incluido en el prompt construido por el nodo Code.

---

## 4. Nodos del workflow

### 4.1 Manual Trigger

Este nodo inicia manualmente el workflow.

Se utiliza durante las pruebas para ejecutar el flujo de forma controlada desde la interfaz de n8n.

---

### 4.2 Edit Fields

Este nodo define el campo:

```text
pregunta_usuario
```

Ejemplo:

```text
¿Cuál es la política de cancelación?
```

Este campo representa la pregunta que será enviada al asistente.

---

### 4.3 Code in JavaScript

Este es el nodo principal del MVP actual.

Su función es:

1. Leer la pregunta desde `pregunta_usuario`.
2. Construir el prompt del asistente.
3. Incluir el contexto autorizado del hotel.
4. Crear el cuerpo JSON para Ollama.
5. Enviar la solicitud a Ollama mediante `this.helpers.httpRequest`.
6. Devolver la respuesta del modelo como salida del nodo.

El nodo Code utiliza una solicitud HTTP interna hacia Ollama, pero no depende del nodo visual HTTP Request.

---

## 5. Motivo del cambio de HTTP Request a Code Node

Inicialmente se intentó usar el nodo **HTTP Request** de n8n para consultar Ollama.

Sin embargo, durante las pruebas se presentaron errores relacionados con el envío del JSON, especialmente con el parámetro:

```json
"stream": false
```

Ollama esperaba un valor booleano real, pero el nodo HTTP Request llegó a enviarlo como texto en ciertas configuraciones.

Esto produjo errores de tipo en la solicitud.

Para estabilizar el flujo, se reemplazó el nodo HTTP Request por un nodo **Code in JavaScript**, donde se controla de forma directa el cuerpo de la petición:

```javascript
this.helpers.httpRequest({
  method: "POST",
  url: "http://ollama:11434/api/generate",
  headers: {
    "Content-Type": "application/json"
  },
  body,
  json: true
});
```

Esta decisión permitió estabilizar el MVP y asegurar que Ollama recibiera correctamente los datos.

---

## 6. Flujo de datos

El flujo de datos actual es:

```text
1. El usuario define una pregunta en Edit Fields.
2. n8n ejecuta el workflow manualmente.
3. El nodo Code recibe la pregunta.
4. El nodo Code construye el prompt con contexto del hotel.
5. El nodo Code envía la petición a Ollama.
6. Ollama ejecuta el modelo qwen2.5:7b.
7. El modelo genera una respuesta.
8. El nodo Code devuelve la respuesta en el campo respuesta_ollama.
```

---

## 7. Entrada del sistema

La entrada actual del sistema es una pregunta de texto en el nodo Edit Fields.

Ejemplo:

```text
¿Qué tipos de habitaciones ofrece el hotel?
```

---

## 8. Salida del sistema

La salida del sistema se entrega desde el nodo Code.

La respuesta principal se almacena en:

```text
respuesta_ollama
```

Ejemplo:

```text
El hotel ofrece habitación sencilla, habitación doble, habitación triple, habitación familiar y suite.
```

---

## 9. Contexto autorizado

El contexto actual del asistente incluye información sobre:

- nombre del hotel;
- tipos de habitaciones;
- horarios;
- servicios;
- política de cancelación;
- mascotas;
- pagos;
- información no disponible.

El modelo debe responder únicamente usando ese contexto.

---

## 10. Control de alucinaciones

El prompt incluye reglas para evitar que el modelo invente información.

Cuando una pregunta no está cubierta por el contexto, el asistente debe responder:

```text
No tengo información suficiente en el documento del hotel para responder eso.
```

Esto fue validado con preguntas trampa como:

- ¿Tiene el hotel servicio de lavandería?
- ¿Cuál es la contraseña exacta del Wi-Fi?

---

## 11. Estado actual de la arquitectura

Estado actual:

- Docker Compose funcionando.
- n8n funcionando.
- Ollama funcionando.
- Modelo `qwen2.5:7b` disponible.
- Workflow funcional usando Code Node.
- Pruebas PF-01 a PF-10 aprobadas.
- Evidencias visuales conservadas localmente.

---

## 12. Limitaciones arquitectónicas

La arquitectura actual es funcional como MVP, pero tiene limitaciones:

- El contexto está dentro del código/prompt.
- No se leen documentos externos automáticamente.
- No se usan PDFs.
- No se usa Google Docs.
- No se usa AI Agent como flujo principal.
- No se usa base vectorial.
- No existe una interfaz conversacional externa como Telegram.

---

## 13. Mejoras futuras

Las mejoras futuras propuestas son:

```text
Documento externo
→ extracción de texto
→ fragmentación
→ embeddings
→ base vectorial
→ recuperación de contexto
→ respuesta con Ollama
```

También se plantea explorar:

- GitHub RAW como fuente de documentos;
- Google Docs publicado;
- PDF de políticas, manual de usuario o PQRS;
- AI Agent en n8n;
- PostgreSQL/pgvector;
- Telegram o Webhook;
- módulo de reservas.