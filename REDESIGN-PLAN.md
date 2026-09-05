# Plan de rediseño: gfandos.com

**Fecha**: septiembre 2026
**Rama**: `claude/academic-website-redesign-315sf9`
**Referencia visual**: Quantitative Biodiversity Lab (Laura Pollock, McGill), qbiodiversity.org

---

## 1. Diagnóstico

La auditoría de febrero (AUDIT-REPORT.md) sigue siendo válida en lo esencial: buen texto, estructura clara, pocas imágenes. Lo que ha cambiado desde entonces, y lo que esa auditoría no vio:

### Contenido y currículo (corregir ya)

| Problema | Detalle | Dónde |
|---|---|---|
| Título de paper incorrecto | El paper de *Communications Biology* 2026 se publicó como **"Simple mechanistic traits outperform complex syndromes in predicting avian dispersal distances"** (Comm Biol 9: 376). En la web aparece con el título del preprint ("Dispersal syndromes across the tree of life"). | index.qmd, publications.qmd, research/dispersal.qmd |
| Paper de 2026 ausente | Wolff, J., **Fandos, G.**, Albert, C. H., Bocedi, G., Travis, J., & Zurell, D. (2026). *Habitat fragmentation and amount drive within-species variation in dispersal kernels and limit transferability across landscapes.* **Oikos**, doi:10.1002/oik.12209. Encaja directamente en la narrativa de INTRADISP. | publications.qmd, research/dispersal.qmd |
| Noticias congeladas | Última entrada: febrero 2026. Una portada con noticias de hace siete meses transmite abandono. | index.qmd |
| Fechas de proyecto | INTRADISP figura como 2024-2026. Si termina en diciembre, conviene decidir ya cómo se presentará (resultados, continuación). | projects/ |
| Sin CV | No hay página de CV ni PDF descargable. Es lo primero que busca un evaluador o un candidato a TFM/doctorado. | nuevo cv.qmd |
| "Twitter" | Icono y texto siguen diciendo Twitter. | _quarto.yml, index.qmd |

No he podido verificar Google Scholar, ORCID ni el perfil UCM desde este entorno (bloqueados). Puede haber más publicaciones 2024-2025 que faltan; revisa el apartado 6.

### Técnico

| Problema | Detalle |
|---|---|
| `favicon.png` es un JPEG de 840x539 | No es cuadrado ni PNG. Los navegadores lo recortan mal. Hace falta un PNG 512x512 (y un `apple-touch-icon`). |
| `avatar.jpg` de 400x368, calidad 65 | Se muestra a 15em (unos 240 px CSS). En pantallas retina se ve borroso. Hace falta un original de al menos 800 px. |
| Banners subidos pero sin usar | `banner.png` (2,4 MB) y `banner_bis.png` (2,9 MB) no se referencian en ninguna página ni se copian a `docs/`. Hay que convertirlos a WebP/JPEG a 1920 px (unos 200-300 KB). |
| Fuentes importadas dos veces | El mismo `@import` de Google Fonts está en `custom.scss` y en `custom.css`. Además, Google Fonts retiró "Source Sans Pro" a favor de "Source Sans 3"; comprobar que la petición actual no está devolviendo un 400 silencioso. |
| Tarjetas por selector genérico | `.g-col-12.g-col-md-4` y `.g-col-md-6` reciben fondo blanco, borde y sombra. Cualquier grid futuro heredará ese aspecto aunque no sea una tarjeta. |
| Contenido "en caja" | `main.content` va en una caja blanca sobre fondo crema con sombra. Es el aspecto Bootstrap de 2018 y limita el uso de secciones a ancho completo. |
| `ucm.svg` de 645 KB | Un logotipo vectorial no debería pesar más que una foto. Probablemente incrusta una imagen raster. |
| Sin despliegue automático | El README habla de GitHub Actions pero no hay `.github/workflows/`. El sitio se publica desde `docs/` renderizado a mano. |

### Estructura

- **Outreach & Field Technology** mezcla tres cosas distintas (tecnología de campo, divulgación, editorial) que encajan mejor en otras páginas.
- **Field Technology** aparece como cuarta línea de investigación en research/index.qmd pero no en el menú ni con subpágina.
- Estudiantes descritos en people.qmd y teaching.qmd; colaboradores en people.qmd y research/index.qmd.
- SHAREPOINT sin subpágina; INTRADISP y RIMed-Fauna sí la tienen.

---

## 2. Qué tomar del Quantitative Biodiversity Lab (y qué no)

No he podido cargar qbiodiversity.org desde este entorno; lo que sigue se basa en lo que conozco de esa web y de la familia de webs de laboratorio a la que pertenece.

**Lo que funciona en la web de Pollock y merece copiarse:**

1. **Identidad de grupo, no de persona.** El sitio se llama "Quantitative Biodiversity Lab", no "Laura Pollock". Eso cambia el tono: se habla de "we", se listan personas, se anima a unirse. Tu web ya tiene equipo (tres estudiantes, colaboradores estables, proyectos con financiación) pero se presenta como un perfil personal.
2. **Foto a ancho completo en cabecera** con una frase corta de misión encima. Nada de avatar redondo en la primera pantalla.
3. **Página de personas en cuadrícula** con foto, nombre, rol y dos líneas. Alumni en lista aparte. "Join us" visible.
4. **Publicaciones por año**, con miembros del lab en negrita, enlace a DOI y a código/datos.
5. **Noticias como listado propio** (entradas breves con fecha), no una lista manual en la portada.
6. **Temas de investigación con imagen**, tres o cuatro, cada uno con dos frases y un enlace.

**Lo que no conviene copiar:**

- Es un WordPress con entradas de blog antiguas y páginas desiguales. Quarto te da lo mismo con menos mantenimiento.
- Las paletas genéricas de tema WordPress. Tú ya tienes un activo visual propio (los banners ilustrados) del que puede salir toda la identidad.

---

## 3. Concepto visual

### Decisión previa: ¿nombre de grupo?

Recomiendo presentar la web como grupo con tu nombre como PI, por ejemplo **"Spatial Ecology & Movement Lab · UCM"** con "Guillermo Fandos" como subtítulo, y mantener gfandos.com como dominio. Si prefieres mantener el sitio como personal, el resto del plan sigue siendo válido; solo cambia la cabecera y el pronombre (I/we).

### Imagen de cabecera

`banner_bis.png` (acuarela: cámara trampa, satélite, ave, corzo, zorro, líneas de movimiento) resume tu investigación mejor que cualquier texto: sensores en campo, teledetección, movimiento animal. Es la imagen de portada. `banner.png` (versión azul/grisácea) sirve como cabecera de las páginas interiores o para el modo oscuro.

### Paleta (derivada de la acuarela)

| Uso | Color | Nota |
|---|---|---|
| Fondo | `#f7f3ea` | Papel cálido, tono del banner |
| Texto | `#2b2f2a` | Casi negro con matiz verde |
| Primario (enlaces, botones) | `#4f6b3f` | Verde oliva del follaje |
| Acento | `#c2913a` | Ocre de las líneas de trayectoria |
| Secundario | `#5f6e75` | Gris pizarra del satélite / cámara |
| Superficie de tarjeta | `#ffffff` | Con borde `#e6e0d2`, sin sombra |

Contraste: primario sobre fondo 6.1:1, texto sobre fondo 13:1 (ambos AA/AAA).

### Tipografía

- Títulos: **Fraunces** (serif con carácter, funciona bien grande) o **Source Serif 4** si prefieres algo más sobrio.
- Cuerpo: **Source Sans 3** (sucesora oficial de Source Sans Pro) o **Inter**.
- Tamaño base 17-18 px, interlineado 1.6, ancho de columna de texto 68-72 caracteres.

### Composición

- Sin caja blanca central: el contenido va directamente sobre el fondo, con secciones a ancho completo que alternan fondo papel y blanco.
- Cabecera: imagen a ancho completo (60-70 vh en escritorio, 40 vh en móvil), degradado inferior, título y frase de misión, dos botones ("Research", "Join us").
- Barra de navegación transparente sobre la imagen y opaca al hacer scroll (Quarto lo soporta con `headroom`).
- Tarjetas solo donde hay una clase explícita (`.card-research`, `.card-project`, `.card-person`), nunca por selector de grid.

---

## 4. Arquitectura de información propuesta

```
Home
Research
  ├─ Movement & Dispersal
  ├─ Monitoring & Modelling
  ├─ Conservation & Global Change
  └─ Field Technology            (nueva subpágina; absorbe la parte técnica de Outreach)
Projects
  ├─ INTRADISP
  ├─ RIMed-Fauna
  └─ SHAREPOINT                  (nueva)
People                           (cuadrícula con fotos + alumni + Join us)
Publications                     (generada desde YAML/BibTeX, por año)
Teaching
News                             (listado Quarto; sustituye la lista manual de la portada)
CV                               (página resumen + PDF)
```

Outreach desaparece como página: tecnología de campo pasa a Research, editorial y divulgación pasan a CV, y experiencia de campo pasa a CV. Se conserva `outreach.html` como redirección para no romper enlaces externos.

### Portada, de arriba abajo

1. **Cabecera** con banner, nombre del grupo, frase de misión: *"We study how animals move, where they live, and how to keep them there."*
2. **Tres líneas de investigación** en tarjetas con imagen (recortes del banner o fotos de campo).
3. **Proyectos activos** (INTRADISP, RIMed-Fauna, SHAREPOINT) con financiador y rol.
4. **Últimas noticias** (tres entradas automáticas del listado).
5. **Publicación destacada** con figura: el paper de Comm Biol 2026.
6. **Equipo** en miniatura (fotos redondas, enlace a People).
7. **Pie** con dirección, logos (UCM, financiadores) y enlaces académicos.

Tu foto y bio pasan a People (como PI, arriba) y a CV. No desaparecen; dejan de ser lo primero que se ve.

---

## 5. Plan por fases

### Fase 0: corrección de contenido y CV (medio día)

- [ ] Corregir título y cita del paper de Comm Biol 2026 en las tres páginas.
- [ ] Añadir Wolff et al. 2026 (*Oikos*) a Publications y a Dispersal.
- [ ] Añadir tus publicaciones 2024-2025 que falten (ver apartado 6).
- [ ] Actualizar News: paper de Oikos, cierre de curso, congresos de 2026, cambios de equipo.
- [ ] Twitter → X en icono y texto; valorar añadir Bluesky si lo usas.
- [ ] Crear `cv.qmd` con posiciones, formación, financiación, supervisión, editorial, y enlace a PDF.
- [ ] Favicon PNG cuadrado 512x512.

### Fase 1: sistema de diseño (1-2 días)

- [ ] Reescribir `custom.scss`: variables de color y tipografía, eliminar la caja de `main.content`, quitar tarjetas por selector genérico, definir clases `.card-*`.
- [ ] Borrar `custom.css` o dejarlo solo para lo que SCSS no cubra. Un único `@import` de fuentes.
- [ ] Cabecera de portada con banner a ancho completo (`include-in-header` o `title-block-banner` personalizado).
- [ ] Banner reducido en páginas interiores (`banner.png`, 220 px de alto).
- [ ] Optimizar imágenes: banners a WebP 1920 px, avatar nuevo a 800 px, `ucm.svg` limpio.
- [ ] Navbar: nombre del grupo a la izquierda, iconos a la derecha, transparente sobre banner.
- [ ] Pie de página a tres columnas con logos.
- [ ] Modo oscuro (`theme: light/dark`) usando `banner.png` como versión oscura de la cabecera.

### Fase 2: estructura y contenido (2-3 días)

- [ ] `people.qmd` en cuadrícula con fotos (`images/people/`), alumni, Join us.
- [ ] `publications.yml` + listado Quarto agrupado por año, con negrita automática para miembros del grupo. Alternativa: BibTeX exportado de Zotero.
- [ ] `news/` con listado Quarto y una entrada por noticia (migrar las tres existentes).
- [ ] `research/fieldtech.qmd` y `projects/sharepoint.qmd`.
- [ ] Imágenes para las tarjetas de investigación (3) y proyectos (3).
- [ ] Deduplicar: estudiantes solo en People, colaboradores solo en People, publicaciones "selected" en research/* limitadas a tres con enlace a la lista completa.
- [ ] Redirección de `outreach.html`.

### Fase 3: infraestructura y visibilidad (medio día)

- [ ] GitHub Actions: `quarto render` + despliegue a Pages en cada push a `main`. Sacar `docs/` del repositorio.
- [ ] JSON-LD `Person` + `ResearchOrganization` en la portada.
- [ ] Analítica sin cookies (Plausible o GoatCounter).
- [ ] Versión en español de portada, People y Teaching (Quarto soporta `lang` por página; una carpeta `es/` es lo más simple). Tu docencia es en español y muchos candidatos a TFM buscarán en español.

Tiempo total estimado: 5-7 días de trabajo efectivo, repartibles.

---

## 6. Qué necesito de ti

1. **Decisión**: ¿web de grupo con nombre propio, o web personal? (apartado 3)
2. **Fotos**: retrato tuyo a alta resolución; retratos de David, Claudia y Hugo; 3-6 fotos de campo horizontales (cámaras trampa, anillamiento, río mediterráneo, Estrecho).
3. **CV en PDF** actualizado, o los datos: posiciones con fechas (Potsdam, Humboldt, UCM), financiación obtenida con importes, índice h si quieres mostrarlo.
4. **Lista de publicaciones 2024-2025** exportada de Scholar u ORCID (BibTeX o CSV). No he podido acceder a esos perfiles.
5. **Noticias de 2026** que quieras que aparezcan: congresos, TFM defendidos, nuevas incorporaciones, financiación.
6. **Logos** de financiadores que quieras mostrar (Parques Nacionales, UCM, DFG si se mantiene BIOPIC en pasados).

Con los puntos 1 y 3 puedo ejecutar la Fase 0 y la Fase 1 completas sin esperar a las fotos.
