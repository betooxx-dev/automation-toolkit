#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_banner() {
    echo -e "${BLUE}"
    echo '███╗   ██╗ ██████╗ ██████╗ ███████╗     ██╗███████╗    ██████╗ ██╗     ██╗   ██╗███████╗██████╗ ██████╗ ██╗███╗   ██╗████████╗'
    echo '████╗  ██║██╔═══██╗██╔══██╗██╔════╝     ██║██╔════╝    ██╔══██╗██║     ██║   ██║██╔════╝██╔══██╗██╔══██╗██║████╗  ██║╚══██╔══╝'
    echo '██╔██╗ ██║██║   ██║██║  ██║█████╗       ██║███████╗    ██████╔╝██║     ██║   ██║█████╗  ██████╔╝██████╔╝██║██╔██╗ ██║   ██║   '
    echo '██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██   ██║╚════██║    ██╔══██╗██║     ██║   ██║██╔══╝  ██╔═══╝ ██╔══██╗██║██║╚██╗██║   ██║   '
    echo '██║ ╚████║╚██████╔╝██████╔╝███████╗╚█████╔╝███████║    ██████╔╝███████╗╚██████╔╝███████╗██║     ██║  ██║██║██║ ╚████║   ██║   '
    echo '╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚════╝ ╚══════╝    ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   '
    echo -e "${GREEN}                                                Made with ❤️  by betooxx-dev${NC}"
    echo
}

show_help() {
    echo -e "${YELLOW}Uso:${NC}"
    echo -e "  $0 [opciones]"
    echo
    echo -e "${YELLOW}Opciones:${NC}"
    echo -e "  -n, --name         ${GREEN}Nombre del proyecto (requerido)${NC}"
    echo -e "  -a, --arch         ${GREEN}Arquitectura a utilizar: layers|hexagonal (requerido)${NC}"
    echo -e "  -l, --lang         ${GREEN}Lenguaje a utilizar: js|ts (requerido)${NC}"
    echo -e "  -p, --path         ${GREEN}Ruta donde crear el proyecto (opcional)${NC}"
    echo -e "  -h, --help         ${GREEN}Muestra esta ayuda${NC}"
    echo
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo -e "  $0 -n mi-proyecto -a hexagonal -l ts"
    echo -e "  $0 -n mi-api -a layers -l js -p /ruta/destino"
    echo
    exit 0
}

create_base_files() {
    local language=$1
    local extension=$2

    if [ "$language" = "ts" ]; then
        echo 'import express, { Application } from "express";
import cors from "cors";
import helmet from "helmet";

const app: Application = express();

app.use(cors());
app.use(helmet());
app.use(express.json());

export default app;' > src/app.${extension}

        echo 'import app from "./app";
import dotenv from "dotenv";

dotenv.config();

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});' > src/server.${extension}
    else
        echo 'import express from "express";
import cors from "cors";
import helmet from "helmet";

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());

export default app;' > src/app.${extension}

        echo 'import app from "./app.js";
import dotenv from "dotenv";

dotenv.config();

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});' > src/server.${extension}

        npm pkg set type="module"
        npm pkg set scripts.dev="node --watch src/server.js"
        npm pkg set scripts.start="node src/server.js"
    fi
}

init_typescript() {
    local project_name=$1
    
    npm install --save-dev typescript @types/node ts-node-dev @types/express @types/cors
    
    echo '{
  "compilerOptions": {
    "target": "es2017",
    "module": "commonjs",
    "lib": ["es2017", "esnext.asynciterable"],
    "typeRoots": ["./node_modules/@types", "./src/@types"],
    "allowSyntheticDefaultImports": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "outDir": "./dist",
    "sourceMap": true,
    "esModuleInterop": true,
    "strict": true,
    "rootDir": "./src",
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}' > tsconfig.json

    npm pkg set scripts.dev="ts-node-dev --respawn --transpile-only src/server.ts"
    npm pkg set scripts.build="tsc"
    npm pkg set scripts.start="node dist/server.js"
}

create_base_structure() {
    local project_name=$1
    local project_path=$2
    local language=$3
    
    mkdir -p "$project_path/$project_name"
    cd "$project_path/$project_name"
    
    npm init -y
    npm install express dotenv cors helmet
    
    if [ "$language" = "ts" ]; then
        init_typescript "$project_name"
        mkdir -p src/@types
    fi
    
    touch src/app.${language}
    touch src/server.${language}
    touch .env
    touch .gitignore
    touch README.md
    
    echo "node_modules/
.env
.DS_Store
coverage/
dist/" > .gitignore
}

create_layered_architecture() {
    local project_name=$1
    local project_path=$2
    local language=$3
    
    echo -e "${BLUE}Creando proyecto con arquitectura en capas: $project_name ${NC}"
    
    create_base_structure "$project_name" "$project_path" "$language"
    mkdir -p src/{controllers,services,repositories,models,middlewares,utils,config}
    mkdir -p test
    
    create_base_files "$language" "$language"
    
    echo "# $project_name

## Descripción
Proyecto Node.js con arquitectura en capas usando ${language}.

## Estructura
- controllers: Controladores de la aplicación
- services: Lógica de negocio
- repositories: Capa de acceso a datos
- models: Modelos de datos
- middlewares: Middlewares de la aplicación
- utils: Utilidades y helpers
- config: Configuraciones

## Instalación
\`\`\`bash
npm install
\`\`\`

## Desarrollo
\`\`\`bash
npm run dev
\`\`\`

## Producción
\`\`\`bash
npm run build
npm start
\`\`\`" > README.md
    
    echo -e "${GREEN}Proyecto con arquitectura en capas creado exitosamente en: $(pwd)${NC}"
}

create_hexagonal_architecture() {
    local project_name=$1
    local project_path=$2
    local language=$3
    
    echo -e "${BLUE}Creando proyecto con arquitectura hexagonal: $project_name ${NC}"
    
    create_base_structure "$project_name" "$project_path" "$language"
    mkdir -p src/{application,domain,infrastructure}
    touch src/application/index.${language}
    touch src/infrastructure/dependencies.${language}
    touch src/infrastructure/routes.${language}
    mkdir -p src/application/{services,use-cases}
    mkdir -p src/domain/{entities,value-objects}
    mkdir -p src/infrastructure/{controllers,utilities}
    mkdir -p test
    
    create_base_files "$language" "$language"
    
    echo "# $project_name

## Descripción
Proyecto Node.js con arquitectura hexagonal usando ${language}.

## Estructura
### Application
- services: Interfaz de los servicios de la aplicación
- use-cases: Casos de uso de la aplicación

### Domain
- entities: Entidades del dominio
- value-objects: Objetos de valor

### Infrastructure
- controllers: Controladores de la aplicación
- utilities: Utilidades de la aplicación

## Instalación
\`\`\`bash
npm install
\`\`\`

## Desarrollo
\`\`\`bash
npm run dev
\`\`\`

## Producción
\`\`\`bash
npm run build
npm start
\`\`\`" > README.md
    
    echo -e "${GREEN}Proyecto con arquitectura hexagonal creado exitosamente en: $(pwd)${NC}"
}

resolve_project_path() {
    local path=$1
    
    if [ -z "$path" ]; then
        echo "$(pwd)"
        return
    fi
    
    if [[ "$path" != /* ]]; then
        path="$(pwd)/$path"
    fi
    
    local resolved_path=$(realpath -m "$path")
    echo "$resolved_path"
}

main() {
    show_banner
    
    local PROJECT_NAME=""
    local ARCHITECTURE=""
    local LANGUAGE=""
    local PROJECT_PATH=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                ;;
            -n|--name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -a|--arch)
                ARCHITECTURE="$2"
                shift 2
                ;;
            -l|--lang)
                LANGUAGE="$2"
                shift 2
                ;;
            -p|--path)
                PROJECT_PATH="$2"
                shift 2
                ;;
            *)
                echo -e "${RED}Error: Opción inválida $1${NC}"
                show_help
                ;;
        esac
    done

    if [ -z "$PROJECT_NAME" ] || [ -z "$ARCHITECTURE" ] || [ -z "$LANGUAGE" ]; then
        echo -e "${RED}Error: Faltan argumentos requeridos${NC}"
        show_help
    fi

    if [ "$ARCHITECTURE" != "layers" ] && [ "$ARCHITECTURE" != "hexagonal" ]; then
        echo -e "${RED}Error: La arquitectura debe ser 'layers' o 'hexagonal'${NC}"
        exit 1
    fi

    if [ "$LANGUAGE" != "js" ] && [ "$LANGUAGE" != "ts" ]; then
        echo -e "${RED}Error: El lenguaje debe ser 'js' o 'ts'${NC}"
        exit 1
    fi

    PROJECT_PATH=$(resolve_project_path "${PROJECT_PATH}")
    
    if [ ! -d "$PROJECT_PATH" ]; then
        echo -e "${BLUE}Creando directorio destino: $PROJECT_PATH${NC}"
        mkdir -p "$PROJECT_PATH" || {
            echo -e "${RED}Error: No se pudo crear el directorio destino${NC}"
            exit 1
        }
    fi
    
    if [ ! -w "$PROJECT_PATH" ]; then
        echo -e "${RED}Error: No tienes permisos de escritura en $PROJECT_PATH${NC}"
        exit 1
    fi

    case $ARCHITECTURE in
        "layers")
            create_layered_architecture "$PROJECT_NAME" "$PROJECT_PATH" "$LANGUAGE"
            ;;
        "hexagonal")
            create_hexagonal_architecture "$PROJECT_NAME" "$PROJECT_PATH" "$LANGUAGE"
            ;;
        *)
            echo -e "${RED}Error: Tipo de arquitectura no válido. Use 'layers' o 'hexagonal'${NC}"
            exit 1
            ;;
    esac
}

main "$@"