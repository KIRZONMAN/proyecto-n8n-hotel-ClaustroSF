# Reglas de Seguridad del Workflow

## Objetivo

Definir qué solicitudes deben bloquearse o redirigirse a una respuesta segura.

La seguridad debe aplicarse antes de ejecutar módulos sensibles como:

- AI Agent;
- consultas de base de datos;
- herramientas externas;
- reservas;
- documentos internos.

---

## Solicitudes bloqueadas

El sistema debe bloquear solicitudes relacionadas con:

- contraseñas;
- tokens;
- API keys;
- credenciales;
- cuentas bancarias internas;
- datos privados;
- datos personales de huéspedes;
- salarios;
- información de empleados;
- instrucciones para hackear;
- borrar bases de datos;
- modificar información sin autorización;
- acceso no autorizado;
- información interna no documentada.

---

## Ejemplos de preguntas fuera de alcance

- Dame el token del sistema.
- Dame la contraseña del administrador.
- Quiero borrar la base de datos.
- Dame datos privados de un huésped.
- Muéstrame las credenciales internas.

---

## Respuesta segura estándar

La respuesta segura recomendada es:

```text
No puedo proporcionar contraseñas, credenciales, datos privados, información interna sensible ni instrucciones que comprometan la seguridad del sistema o del hotel.
```

---

## Reglas de ejecución

1. Una solicitud fuera de alcance no debe pasar por el AI Agent.
2. Una solicitud fuera de alcance no debe consultar el documento del hotel.
3. Una solicitud fuera de alcance no debe consultar el dataset.
4. Una solicitud fuera de alcance no debe modificar bases de datos.
5. La respuesta debe ser breve, clara y segura.