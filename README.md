# Talent Reminder

## Español

**Talent Reminder** es un addon para World of Warcraft que muestra un recordatorio visual para revisar o cambiar tus talentos al entrar en los lugares que hayas seleccionado.

El addon permite elegir de forma independiente **Mundo**, las distintas **expansiones** y la **Temporada actual**.

### ¿Cómo funciona?

Cuando el jugador cambia de zona o entra en una instancia, Talent Reminder comprueba primero si WoW indica que el personaje está realmente en **Mundo**.

Para Talent Reminder:

> **Mundo = cuando WoW indica que el jugador está fuera de una instancia (`instanceType = "none"`).**

Por tanto, una `instanceID` que no esté configurada **no se considera Mundo automáticamente**. Si el jugador está dentro de una instancia no configurada, simplemente no se muestra el aviso.

Si el jugador no está en Mundo, el addon obtiene la `instanceID` actual y comprueba si pertenece a alguno de los grupos activados.

- **Mundo**: muestra el aviso al entrar en el mundo si está activado.
- **Expansiones**: cada expansión puede activarse o desactivarse de forma independiente.
- **Temporada actual**: es un grupo independiente que permite incluir instancias de la rotación actual aunque originalmente pertenezcan a otra expansión.
- Una misma `instanceID` puede pertenecer a más de un grupo. El aviso se muestra si **al menos uno de esos grupos está activado**.
- Si la instancia no pertenece a ningún grupo activado, no se muestra el aviso.

Mientras el jugador permanece en Mundo, cambiar entre zonas de Mundo **no vuelve a mostrar el recordatorio**. Al entrar en una instancia, el estado de Mundo se reinicia para que el aviso pueda volver a mostrarse la próxima vez que se regrese al Mundo.

### Selección de contenido

En las opciones hay un desplegable **Expansiones** con los siguientes grupos:

- Todas
- Mundo
- Classic
- The Burning Crusade
- Wrath of the Lich King
- Cataclysm
- Mists of Pandaria
- Warlords of Draenor
- Legion
- Battle for Azeroth
- Shadowlands
- Dragonflight
- The War Within
- Midnight
- Temporada actual

**Todas** activa o desactiva todos los grupos, incluido Mundo y Temporada actual.

Por defecto, todas las expansiones y **Temporada actual** están activadas. **Mundo** está desactivado por defecto.

### Temporada actual

**Temporada actual** no representa una expansión. Es un grupo adicional pensado para las instancias que forman parte de la temporada vigente.

Esto permite, por ejemplo, tener una expansión antigua desactivada y seguir recibiendo el aviso en una de sus mazmorras si esa mazmorra también está incluida en **Temporada actual**.

Las `instanceID` de este grupo se mantienen en `Core/Instances.lua`, igual que las de las expansiones.

### Recordatorio

El aviso aparece como un texto grande en pantalla y puede personalizarse desde las opciones del addon.

Es posible configurar:

- Texto del recordatorio.
- Color del texto: Blanco, Rojo, Verde o Naranja.
- Tamaño de la fuente.
- Duración total del aviso.
- Duración del efecto de desaparición (Fade out).
- Posición del aviso.
- Sonido del aviso.
- Mundo, expansiones y Temporada actual donde debe mostrarse.

La posición del recordatorio puede desbloquearse y moverse directamente por la pantalla.

### Sonidos

Talent Reminder incluye sonidos nativos de World of Warcraft.

También puede detectar **LibSharedMedia-3.0** si ya está disponible a través de otro addon. Cuando LibSharedMedia está disponible, sus sonidos registrados aparecen automáticamente entre las opciones de sonido de Talent Reminder.

Talent Reminder **no depende de LibSharedMedia** para funcionar.

Si un sonido de SharedMedia seleccionado deja de estar disponible, el addon utiliza el sonido **Raid Warning** de World of Warcraft como alternativa.

### Idiomas

Talent Reminder detecta automáticamente el idioma del cliente de World of Warcraft.

Actualmente incluye:

- Español
- English

Los clientes `esES` y `esMX` utilizan español. Los demás idiomas utilizan inglés como idioma predeterminado.

### Comandos

| Comando | Función |
|---|---|
| `/tr` | Abre las opciones de Talent Reminder. |
| `/tr test` | Muestra un recordatorio de prueba con la configuración actual. |
| `/tr move` | Activa o desactiva el modo para mover el recordatorio. |
| `/tr id` | Muestra información de la instancia actual, incluida su `instanceID`. |
| `/tr stop` | Detiene y oculta el recordatorio actual. |
| `/tr instances` | Abre una ventana con mazmorras, bandas y Delves agrupados por expansión. **Copiar todo** selecciona el texto para copiarlo con `Ctrl+C`. |

### Estructura interna

- `Bootstrap.lua`: crea el espacio compartido del addon y la función de traducción.
- `Core/Defaults.lua`: contiene la configuración predeterminada.
- `Core/Expansions.lua`: define los grupos seleccionables y su orden en la interfaz: Mundo, expansiones y Temporada actual.
- `Core/Instances.lua`: contiene las `instanceID` agrupadas por expansión/Temporada actual y la lógica para comprobar instancias y Mundo.
- `Core/Sounds.lua`: gestiona los sonidos nativos y el soporte opcional para LibSharedMedia-3.0.
- `Core/Reminder.lua`: crea y controla el recordatorio visual.
- `Options/Options.lua`: construye la interfaz de opciones.
- `Tools/InstanceDump.lua`: contiene la herramienta de diagnóstico utilizada por `/tr instances`.
- `Locales/`: contiene los textos traducibles del addon.

---

## English

**Talent Reminder** is a World of Warcraft addon that displays a visual reminder to review or change your talents when entering selected locations.

The addon lets you independently select **World**, individual **expansions**, and the **Current Season**.

### How does it work?

Whenever the player changes zones or enters an instance, Talent Reminder first checks whether WoW reports that the character is actually in the **World**.

For Talent Reminder:

> **World = when WoW reports that the player is outside an instance (`instanceType = "none"`).**

Therefore, an unconfigured `instanceID` is **not automatically considered World**. If the player is inside an unconfigured instance, the reminder simply does not appear.

When the player is not in the World, the addon obtains the current `instanceID` and checks whether it belongs to any enabled group.

- **World**: displays the reminder when entering the World if enabled.
- **Expansions**: each expansion can be enabled or disabled independently.
- **Current Season**: an independent group that can contain instances from the current rotation even when they originally belong to an older expansion.
- The same `instanceID` can belong to more than one group. The reminder is displayed when **at least one of those groups is enabled**.
- If the instance does not belong to any enabled group, no reminder is displayed.

While the player remains in the World, moving between World zones **does not display the reminder again**. Entering an instance resets the World state so the reminder can appear again the next time the player returns to the World.

### Content selection

The settings contain an **Expansions** dropdown with these groups:

- All
- World
- Classic
- The Burning Crusade
- Wrath of the Lich King
- Cataclysm
- Mists of Pandaria
- Warlords of Draenor
- Legion
- Battle for Azeroth
- Shadowlands
- Dragonflight
- The War Within
- Midnight
- Current Season

**All** enables or disables every group, including World and Current Season.

By default, all expansions and **Current Season** are enabled. **World** is disabled by default.

### Current Season

**Current Season** is not an expansion. It is an additional group intended for instances that are part of the active seasonal rotation.

For example, an older expansion can be disabled while a dungeon from that expansion can still trigger the reminder when that dungeon is also included in **Current Season**.

The `instanceID` values for this group are maintained in `Core/Instances.lua`, just like the expansion groups.

### Reminder

The reminder appears as large text on the screen and can be customized through the addon's settings.

You can configure:

- Reminder text.
- Text color: White, Red, Green or Orange.
- Font size.
- Total display duration.
- Fade-out duration.
- Reminder position.
- Reminder sound.
- World, expansions and Current Season where the reminder should appear.

The reminder position can be unlocked and moved directly around the screen.

### Sounds

Talent Reminder includes native World of Warcraft sounds.

It can also detect **LibSharedMedia-3.0** when the library is already available through another addon. When LibSharedMedia is available, its registered sounds automatically become available in Talent Reminder's sound options.

Talent Reminder **does not require LibSharedMedia** to work.

If a selected SharedMedia sound is no longer available, the addon falls back to World of Warcraft's **Raid Warning** sound.

### Languages

Talent Reminder automatically detects the World of Warcraft client's language.

Currently included:

- Español
- English

`esES` and `esMX` clients use Spanish. All other client locales use English as the default language.

### Commands

| Command | Function |
|---|---|
| `/tr` | Opens the Talent Reminder settings. |
| `/tr test` | Displays a test reminder using the current configuration. |
| `/tr move` | Enables or disables reminder positioning mode. |
| `/tr id` | Displays information about the current instance, including its `instanceID`. |
| `/tr stop` | Stops and hides the current reminder. |
| `/tr instances` | Opens a window containing dungeons, raids and Delves grouped by expansion. **Copy all** selects the text so it can be copied with `Ctrl+C`. |

### Internal structure

- `Bootstrap.lua`: creates the addon's shared namespace and translation function.
- `Core/Defaults.lua`: contains the default configuration.
- `Core/Expansions.lua`: defines the selectable groups and their UI order: World, expansions and Current Season.
- `Core/Instances.lua`: contains the `instanceID` values grouped by expansion/Current Season and the logic used to check instances and World.
- `Core/Sounds.lua`: manages native sounds and optional LibSharedMedia-3.0 support.
- `Core/Reminder.lua`: creates and controls the visual reminder.
- `Options/Options.lua`: builds the settings interface.
- `Tools/InstanceDump.lua`: contains the diagnostic utility used by `/tr instances`.
- `Locales/`: contains the addon's translatable strings.
