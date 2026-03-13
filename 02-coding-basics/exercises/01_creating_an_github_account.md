# 💻 Práctica: Creación de una cuenta en GitHub y primeros pasos con GitHub Codespaces

## Introducción

En la bioinformática moderna, las herramientas computacionales son tan esenciales como el propio laboratorio húmedo o tradicional de bata. Secuenciar un genoma, comparar miles de proteínas o reconstruir una historia evolutiva son tareas que dependen completamente de la capacidad de ejecutar comandos, organizar archivos y automatizar análisis en un entorno de línea de comandos. Sin embargo, instalar y configurar un entorno de trabajo funcional puede ser una barrera inicial importante, especialmente cuando se trabaja en sistemas operativos diferentes.

Para superar este obstáculo, en este módulo utilizaremos **GitHub Codespaces**: un entorno de desarrollo completo basado en la nube que se ejecuta directamente desde el navegador, sin necesidad de instalar software adicional. Codespaces proporciona acceso a una terminal Unix totalmente funcional, con herramientas de programación preinstaladas y la posibilidad de trabajar desde cualquier dispositivo con conexión a internet.

Pero antes de usar Codespaces, necesitamos crear una cuenta en **GitHub**, la plataforma de alojamiento de código y proyectos más utilizada en el mundo. GitHub no es solo un repositorio de código: es también una red de colaboración científica donde se comparten pipelines bioinformáticos, scripts de análisis, flujos de trabajo reproducibles y datos de proyectos de investigación.

En esta práctica, aprenderá a crear una cuenta en GitHub, explorar la plataforma y configurar su primer espacio de trabajo en Codespaces, que usaremos durante las siguientes sesiones para aprender los fundamentos de la línea de comandos Unix.

---

## 🎯 Objetivos

- Crear una cuenta personal en **GitHub**.
- Explorar la interfaz principal de GitHub e identificar sus secciones clave.
- Acceder y configurar un entorno de trabajo en **GitHub Codespaces**.
- Familiarizarse con la terminal Unix dentro de Codespaces y ejecutar los primeros comandos.

---

## 📦 Requisitos previos

- Computador con **Windows/Linux/macOS**.
- Conexión a internet.
- Una dirección de **correo electrónico** válida (puede ser personal o institucional). Te recomiendo usar la cuenta institucional para que tengas acceso a recursos educativos como copilot y otros beneficios de GitHub Education.
- Navegador web actualizado (se recomienda **Google Chrome** o **Mozilla Firefox**).

---

## 🔬 Procedimiento

### Parte 1: ¿Qué es GitHub?

**GitHub** es una plataforma basada en la nube que permite almacenar, gestionar y compartir código mediante el sistema de control de versiones **Git**. En bioinformática, se utiliza ampliamente para:

- Compartir y documentar **scripts y pipelines** de análisis.
- Colaborar en proyectos de análisis de datos de manera reproducible.
- Acceder a herramientas y flujos de trabajo desarrollados por la comunidad científica.
- Gestionar versiones de proyectos (saber qué cambió, cuándo y por quién).

Algunos conceptos clave que encontrará en GitHub:

| Término                | Descripción                                                          |
|------------------------|----------------------------------------------------------------------|
| **Repositorio (repo)** | Carpeta o proyecto almacenado en GitHub                              |
| **Commit**             | Registro de un cambio realizado en el proyecto                       |
| **Branch**             | Versión paralela de un proyecto para desarrollo independiente        |
| **Fork**               | Copia personal de un repositorio ajeno                               |
| **Codespace**          | Entorno de desarrollo en la nube, listo para usar desde el navegador |

---

### Parte 2: Crear una cuenta en GitHub

#### Paso a paso:

1. **Acceder a la URL**: [https://github.com](https://github.com)
2. **Registrarse**: Haz clic en el botón **Sign up** (esquina superior derecha).
3. **Ingresar datos**:
   - Dirección de correo electrónico.
   - Contraseña segura (mínimo 8 caracteres, con letras, números y símbolos).
   - Nombre de usuario único (este será tu identidad pública en GitHub, ej. `juanperez-bio`).
4. **Verificar humanidad**: Completar el CAPTCHA de verificación.
5. **Confirmar correo**: GitHub enviará un código de verificación a tu correo. Ingrésalo para activar la cuenta.
6. **Configurar el perfil** (opcional pero recomendado):
   - Ve a tu foto de perfil (esquina superior derecha) → `Settings`.
   - Agrega tu nombre completo, institución y una foto de perfil.

> 💡 **Consejo**: Elige un nombre de usuario profesional. Este nombre aparecerá en todos tus repositorios públicos y es frecuentemente usado como referencia en el ámbito académico y laboral.

---

### Parte 3: Explorar la interfaz de GitHub

Una vez creada la cuenta, tómate unos minutos para explorar la plataforma:

- **Dashboard** (página de inicio): Muestra actividad reciente, repositorios sugeridos y notificaciones.
- **Explore** ([github.com/explore](https://github.com/explore)): Descubre proyectos populares organizados por temática. Busca términos como `bioinformatics`, `RNA-seq` o `phylogenetics`.
- **Tu perfil**: Accesible desde tu avatar en la esquina superior derecha. Aquí se muestran tus repositorios, contribuciones y actividad.
- **Repositorios**: Haz clic en `+` → `New repository` para ver cómo se crea un proyecto nuevo (no es necesario crearlo aún).

---

### Parte 4: Acceder a GitHub Codespaces

**GitHub Codespaces** proporciona un entorno de desarrollo completo en la nube basado en **Visual Studio Code**, con una terminal Unix integrada. Para esta práctica, usaremos un repositorio de ejemplo preparado para el curso.

#### Paso a paso:

1. **Acceder al repositorio del curso**: Tu instructor compartirá el enlace al repositorio. Accede a él desde tu cuenta de GitHub.
2. **Abrir un Codespace**:
   - Dentro del repositorio, haz clic en el botón verde **`<> Code`**.
   - Selecciona la pestaña **`Codespaces`**.
   - Haz clic en **`Create codespace on main`**.
3. **Esperar la inicialización**: GitHub hare un `fork` (una copia) y construirá el entorno automáticamente. Esto puede tomar entre 1 y 3 minutos la primera vez.
4. **Explorar el entorno**:
   - El editor **Visual Studio Code** se abrirá en el navegador.
   - Identifica el **explorador de archivos** (panel izquierdo), el **editor de código** (panel central) y la **terminal** (panel inferior).
5. **Abrir la terminal**: Si la terminal no está visible, ve a `Terminal` → `New Terminal` en el menú superior, o usa el atajo `` Ctrl + ` ``.

> 💡 **Nota**: Cada Codespace es un contenedor Linux independiente. Los archivos creados allí se guardan en tu cuenta de GitHub mientras el Codespace esté activo.

> ⚠️ **¿Los cambios son permanentes?** No del todo. Ten en cuenta lo siguiente:
> - Los archivos **persisten** aunque cierres el navegador, siempre que el Codespace siga activo.
> - GitHub **detiene el Codespace automáticamente** tras ~30 minutos de inactividad (los archivos se conservan, pero el entorno se "congela").
> - Si el Codespace lleva **30 días sin usarse**, GitHub lo **elimina automáticamente** y se pierden todos los cambios que no hayas guardado.
> - La única forma de guardar cambios de forma **permanente y segura** es haciendo `git commit` + `git push` para subirlos al repositorio. Esto lo aprenderemos en sesiones posteriores.
> - En el plan gratuito de GitHub, tienes **120 horas/mes** de uso de Codespaces. Para este curso es más que suficiente.

---

### ToDo: Ejercicio Práctico

**Objetivo**: Verificar que el entorno Codespaces funciona correctamente ejecutando los primeros comandos en la terminal Unix.

Una vez que tengas la terminal abierta en Codespaces, ejecuta los siguientes comandos uno por uno y anota el resultado de cada uno:

1. **¿Quién soy y dónde estoy?**
   ```bash
   whoami
   pwd
   ```
   - `whoami`: muestra el nombre del usuario actual en el sistema.
   - `pwd` (*print working directory*): muestra la ruta del directorio en el que te encuentras.

2. **¿Qué hay en este directorio?**
   ```bash
   ls
   ls -la
   ```
   - `ls`: lista los archivos y carpetas del directorio actual.
   - `ls -la`: muestra la lista con detalles (permisos, tamaño, fecha) incluyendo archivos ocultos.

3. **¿Qué sistema operativo estoy usando?**
   ```bash
   uname -a
   ```
   Muestra información del sistema operativo y el kernel. ¿Reconoces el sistema operativo?

4. **Reto 1**: Crea un directorio llamado `mi_primera_carpeta` y navega dentro de él:
   ```bash
   mkdir mi_primera_carpeta
   cd mi_primera_carpeta
   pwd
   ```
   ¿Cambió la ruta que muestra `pwd`?

5. **Reto 2**: Crea un archivo de texto sencillo con tu nombre y una nota:
   ```bash
   echo "Hola, soy [tu nombre]. Este es mi primer archivo en Unix." > mi_nota.txt
   cat mi_nota.txt
   ```
   ¿Qué hace el símbolo `>`? ¿Qué hace el comando `cat`?

6. **Reto 3**: Vuelve al directorio anterior y lista todo su contenido. ¿Aparece la carpeta que creaste?
   ```bash
   cd ..
   ls
   ```

---

### 📝 Preguntas de Reflexión (Post-Práctica)

Estas preguntas buscan que el estudiante no solo cree una cuenta, sino que reflexione sobre las implicaciones del trabajo colaborativo y reproducible en bioinformática:

**Sobre GitHub y la reproducibilidad**

1. **Control de versiones**: ¿Qué ventaja tiene guardar un script de análisis en GitHub en lugar de simplemente guardarlo en tu computador local? Piensa en un escenario donde trabajas en equipo con otros investigadores en diferentes ciudades.
2. **Repositorios públicos vs. privados**: GitHub permite crear repositorios públicos (visibles para todos) y privados (solo para ti o colaboradores elegidos). Si estuvieras desarrollando un pipeline bioinformático para un artículo científico aún no publicado, ¿usarías un repositorio público o privado? ¿Y después de la publicación?
3. **Codespaces y reproducibilidad**: Una de las ventajas de Codespaces es que el entorno de trabajo es el mismo para todos los estudiantes, independientemente del sistema operativo de su computador personal. ¿Por qué crees que esto es importante en bioinformática, donde los análisis deben ser reproducibles?

**Sobre el entorno Unix**

4. **Terminal vs. interfaz gráfica**: La mayoría de los servidores de cómputo de alto rendimiento (HPC) utilizados en bioinformática solo son accesibles mediante línea de comandos, sin interfaz gráfica. Basándote en los primeros comandos que ejecutaste, ¿qué ventajas crees que tiene trabajar en la terminal frente a usar un programa con botones y menús?
5. **El comando `pwd`**: Ejecutaste `pwd` antes y después de `cd mi_primera_carpeta`. ¿Por qué es importante siempre saber en qué directorio te encuentras cuando trabajas en la terminal? ¿Qué podría salir mal si no lo sabes?

