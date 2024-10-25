# 🏗️ Node.js Blueprint

Un generador elegante y robusto para proyectos Node.js que crea estructuras completas siguiendo patrones de arquitectura modernos.

## 🎯 Visión General

Node.js Blueprint es una herramienta de línea de comandos que automatiza la creación de proyectos Node.js, permitiéndote elegir entre diferentes arquitecturas y lenguajes. Diseñado para ayudarte a comenzar rápidamente con una estructura sólida y bien organizada.

## ✨ Características

- **Arquitecturas Soportadas:**
  - 🏛️ Arquitectura en Capas (Layered)
  - 🔷 Arquitectura Hexagonal

- **Lenguajes:**
  - 📜 JavaScript
  - 🔷 TypeScript (configuración completa)

- **Configuraciones Incluidas:**
  - Express con middlewares esenciales
  - Estructuras de directorios optimizadas
  - Configuración de desarrollo y producción
  - Sistema de tipos completo (TypeScript)

## 🚀 Inicio Rápido

```bash
./nodejs-blueprint.sh -n mi-proyecto -a hexagonal -l ts
```

## 📋 Uso Detallado

```bash
./nodejs-blueprint.sh [opciones]

Opciones:
  -n, --name         Nombre del proyecto (requerido)
  -a, --arch         Arquitectura: layers|hexagonal (requerido)
  -l, --lang         Lenguaje: js|ts (requerido)
  -p, --path         Ruta de destino (opcional)
  -h, --help         Muestra esta ayuda
```

### 📝 Ejemplos

```bash
# Proyecto TypeScript con arquitectura hexagonal
./nodejs-blueprint.sh -n api-servicio -a hexagonal -l ts

# Proyecto JavaScript con arquitectura en capas
./nodejs-blueprint.sh -n mi-api -a layers -l js -p /proyectos/node
```

## 🏗️ Estructuras Generadas

### Arquitectura en Capas
```
src/
├── controllers/    # Controladores de la aplicación
├── services/      # Lógica de negocio
├── repositories/  # Acceso a datos
├── models/        # Modelos de dominio
├── middlewares/   # Middlewares Express
├── utils/         # Utilidades
└── config/        # Configuraciones
```

### Arquitectura Hexagonal
```
src/
├── application/         # Casos de uso y puertos
├── domain/             # Entidades y reglas de negocio
└── infrastructure/     # Adaptadores y configuración
```

## ⚙️ Dependencias

### Core
- express
- dotenv
- cors
- helmet

### TypeScript
- typescript
- @types/node
- @types/express
- @types/cors
- ts-node-dev

## 📦 Scripts Disponibles

### JavaScript
```bash
npm start     # Inicia la aplicación
```

### TypeScript
```bash
npm run dev   # Desarrollo con recarga automática
npm run build # Compila el proyecto
npm start     # Inicia la versión compilada
```

## 🛠️ Personalización

El generador está diseñado para ser extensible. Puedes:
- Modificar las plantillas base
- Agregar nuevas arquitecturas
- Personalizar la configuración de TypeScript
- Añadir dependencias adicionales

## 📝 Notas

- Validación completa de argumentos
- Manejo inteligente de rutas
- Generación automática de documentación
- Configuraciones optimizadas