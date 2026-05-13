# proyecto-n8n-hotel-ClaustroSF

Proyecto académico de Modelado Computacional orientado a la creación de un asistente hotelero usando **n8n**, **Docker Compose**, **Ollama** y el modelo local **qwen2.5:7b**.

El caso de estudio corresponde al **Hotel El Claustro de San Francisco**. La abreviatura **ClaustroSF** se usa únicamente como nombre corto del repositorio/proyecto.

---

## 1. Descripción general

Este proyecto implementa un asistente hotelero básico capaz de responder preguntas sobre:

- nombre del hotel;
- tipos de habitaciones;
- horarios de check-in y check-out;
- política de cancelación;
- mascotas;
- servicios disponibles;
- recepción;
- desayuno;
- preguntas fuera del contexto.

La versión actual funciona como un **MVP** con contexto directo dentro del flujo de n8n. El asistente responde usando la información definida en el prompt/código y evita inventar datos cuando la respuesta no está disponible.

---

## 2. Tecnologías utilizadas

- **Docker Compose:** permite levantar los servicios principales del proyecto.
- **n8n:** herramienta de automatización usada para construir y ejecutar el workflow.
- **Ollama:** servidor local para ejecutar modelos de lenguaje.
- **qwen2.5:7b:** modelo local usado por el asistente.
- **GitHub:** control de versiones y organización del proyecto.
- **Markdown:** documentación del proyecto.
- **JavaScript en Code Node:** usado dentro de n8n para construir la petición hacia Ollama.

---

## 3. Arquitectura funcional actual

El workflow funcional actual es:

```text
Manual Trigger
→ Edit Fields
→ Code in JavaScript
→ Ollama / qwen2.5:7b
→ Respuesta del asistente
```

El nodo **Edit Fields** define la pregunta del usuario mediante el campo:

```text
pregunta_usuario
```

El nodo **Code in JavaScript** construye el prompt, arma el cuerpo de la solicitud y realiza la petición a Ollama usando:

```javascript
this.helpers.httpRequest
```

---

## 4. Motivo del uso de Code Node

Inicialmente se intentó usar el nodo **HTTP Request** de n8n para enviar la petición directamente a Ollama. Sin embargo, durante las pruebas se presentaron problemas de tipado al enviar el cuerpo JSON, especialmente con valores booleanos como:

```json
"stream": false
```

El nodo HTTP Request enviaba algunos valores como texto, lo que provocaba errores de tipo en Ollama.

Por esta razón, se decidió estabilizar el MVP usando un nodo **Code in JavaScript**, ya que permite controlar directamente:

- el cuerpo JSON enviado a Ollama;
- el prompt del asistente;
- el modelo usado;
- el parámetro `stream: false`;
- la lectura de la respuesta;
- el manejo básico de errores.

---

## 5. Ejecución del proyecto

Desde la carpeta raíz del proyecto:

```powershell
docker compose up -d
```

Verificar los contenedores:

```powershell
docker compose ps
```

Verificar que Ollama responda:

```powershell
curl.exe http://localhost:11434/api/tags
```

Abrir n8n en el navegador:

```text
http://localhost:5678
```

---

## 6. Modelo utilizado

El modelo usado actualmente es:

```text
qwen2.5:7b
```

Debe estar disponible dentro del contenedor de Ollama.

Para verificarlo:

```powershell
docker compose exec ollama ollama list
```

---

## 7. Workflow exportado

El workflow funcional debe estar respaldado en:

```text
workflows/asistente_hotel_basico_qwen.json
```

Este archivo debe representar el flujo real actual:

```text
Manual Trigger → Edit Fields → Code in JavaScript → Ollama/qwen2.5:7b
```

---

## 8. Estado actual del proyecto

Estado actual:

- Infraestructura Docker funcionando.
- n8n funcionando.
- Ollama funcionando.
- Modelo `qwen2.5:7b` disponible.
- Workflow funcional estabilizado con Code Node.
- Pruebas funcionales PF-01 a PF-10 ejecutadas y aprobadas.
- Preguntas trampa validadas correctamente.
- Evidencias visuales conservadas localmente en la PC RTX y en la conversación de trabajo.

---

## 9. Pruebas funcionales realizadas

Se ejecutaron y aprobaron pruebas relacionadas con:

- nombre del hotel;
- tipos de habitaciones;
- check-in;
- check-out;
- política de cancelación;
- mascotas;
- lavandería como pregunta fuera de contexto;
- contraseña Wi-Fi como pregunta fuera de contexto;
- recepción 24 horas;
- desayuno.

Las pruebas están documentadas en:

```text
docs/pruebas_funcionales.md
```

---

## 10. Evidencias

Las capturas de las pruebas funcionales se conservan localmente en la PC RTX y en la conversación de trabajo.

Por decisión del equipo, las imágenes de evidencia no se suben al repositorio por ahora, ya que el repositorio se usará principalmente para:

- configuración;
- documentación;
- prompts;
- workflows exportados;
- control de avances.

---

## 11. Estructura del repositorio

```text
proyecto-n8n-hotel-ClaustroSF/
│
├── docker-compose.yml
├── README.md
├── .gitignore
├── .env.example
│
├── control/
│   ├── avances_rtx.md
│   ├── checklist_entrega.md
│   └── README.md
│
├── docs/
│   ├── arquitectura.md
│   ├── explicacion_demo.md
│   ├── plan_trabajo.md
│   ├── pruebas_funcionales.md
│   ├── riesgos_y_limitaciones.md
│   └── README.md
│
├── documentos/
│   ├── Documento_Base_Hotel.md
│   ├── Preguntas_Prueba_Hotel.md
│   └── README.md
│
├── evidencias/
│   ├── pendientes.txt
│   └── README.md
│
├── prompts/
│   ├── prompt_asistente_hotelero.md
│   ├── prompt_cursor.md
│   ├── prompt_kiro.md
│   └── README.md
│
└── workflows/
    ├── asistente_hotel_basico_qwen.json
    └── README.md
```

---

## 12. Limitaciones actuales

La versión actual tiene las siguientes limitaciones:

- El contexto del hotel está incluido directamente en el código/prompt.
- Todavía no se leen documentos externos automáticamente.
- Todavía no se procesan PDFs.
- Todavía no se integra Google Docs.
- Todavía no se usa AI Agent como flujo principal.
- Todavía no se usa Telegram.
- Todavía no existe una base vectorial con PostgreSQL/pgvector.
- El sistema depende de que Docker, n8n, Ollama y `qwen2.5:7b` estén funcionando correctamente en la máquina principal.

---

## 13. Mejoras futuras

Como continuación del proyecto se plantea:

- leer documentos desde GitHub RAW;
- leer documentos publicados desde Google Docs;
- procesar PDFs de políticas, manual de usuario o PQRS;
- usar AI Agent dentro de n8n;
- integrar Telegram o una interfaz conversacional;
- usar PostgreSQL/pgvector como base vectorial;
- separar el contexto del código para hacerlo más escalable;
- crear un flujo de reservas simulado.

---

## 14. Nota de seguridad

No se deben subir al repositorio:

- archivos `.env` reales;
- tokens;
- credenciales;
- contraseñas;
- claves de API;
- volúmenes de Docker;
- modelos de Ollama;
- archivos pesados innecesarios.

El archivo `.env.example` solo debe contener valores de ejemplo.