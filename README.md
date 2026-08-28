# Talent Reminder

## Español

**Talent Reminder** es un addon para World of Warcraft diseñado para mostrar un recordatorio visual al cambiar de zona o entrar en determinadas instancias.

Su objetivo principal es recordar al jugador que revise o cambie sus talentos cuando entra en contenido donde necesita una configuración de talentos específica.

### ¿Cómo funciona?

Cada vez que el jugador cambia de mapa o entra en una instancia, Talent Reminder comprueba la `instanceID` actual.

El addon mantiene internamente una lista de `instanceID` configuradas.

- Si la `instanceID` actual está en la lista, Talent Reminder muestra el aviso.
- Si la `instanceID` no está en la lista, el addon la considera **Mundo**.
- La opción **Avisar en Mundo** permite decidir si también debe mostrarse el recordatorio en las IDs que no están configuradas.

Para Talent Reminder:

> **Mundo = cualquier `instanceID` que no esté incluida en la lista configurada.**

Cuando el aviso de **Mundo** ya se ha mostrado, cambiar entre otras zonas que también se consideran Mundo **no vuelve a mostrar el recordatorio**. El addon recuerda durante la sesión si el jugador ya estaba en Mundo.

El aviso de Mundo vuelve a estar disponible después de entrar en una instancia configurada.


Esta clasificación es independiente del tipo de instancia que World of Warcraft asigne a la zona.

### Recordatorio

El aviso aparece como un texto grande en pantalla y puede personalizarse desde las opciones del addon.

Es posible configurar:

- Texto del recordatorio.
- Tamaño de la fuente.
- Duración del aviso.
- Duración del efecto de desaparición.
- Posición del aviso.
- Sonido del aviso.
- Avisos en Mundo.

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
| `/tr instances` | Imprime mazmorras, bandas y Delves agrupadas por expansión. |
| `/tr instances delves` | Muestra las Delves detectadas de The War Within y Midnight. Para obtener la InstanceID real de una Delve, usa `/tr id` dentro de ella. |
| `/tr instances classic` | Muestra únicamente Classic. |
| `/tr instances tbc` | Muestra únicamente The Burning Crusade. |
| `/tr instances wotlk` | Muestra únicamente Wrath of the Lich King. |
| `/tr instances cata` | Muestra únicamente Cataclysm. |
| `/tr instances mop` | Muestra únicamente Mists of Pandaria. |
| `/tr instances wod` | Muestra únicamente Warlords of Draenor. |
| `/tr instances legion` | Muestra únicamente Legion. |
| `/tr instances bfa` | Muestra únicamente Battle for Azeroth. |
| `/tr instances shadowlands` | Muestra únicamente Shadowlands. |
| `/tr instances dragonflight` | Muestra únicamente Dragonflight. |
| `/tr instances tww` | Muestra únicamente The War Within. |
| `/tr instances midnight` | Muestra únicamente Midnight. |

---

## English

**Talent Reminder** is a World of Warcraft addon designed to display a visual reminder whenever the player changes zones or enters specific instances.

Its main purpose is to remind the player to review or change their talents when entering content that requires a particular talent setup.

### How does it work?

Whenever the player changes maps or enters an instance, Talent Reminder checks the current `instanceID`.

The addon maintains an internal list of configured `instanceID` values.

- If the current `instanceID` is in the list, Talent Reminder displays the reminder.
- If the `instanceID` is not in the list, the addon considers it **World**.
- The **Notify in World** option determines whether the reminder should also appear for IDs that are not configured.

For Talent Reminder:

> **World = any `instanceID` that is not included in the configured list.**

Once the **World** reminder has been shown, moving between other zones that are also considered World **does not show the reminder again**. The addon remembers during the current session whether the player was already in World.

The World reminder becomes available again after entering a configured instance.


This classification is independent of the instance type assigned to the zone by World of Warcraft.

### Reminder

The reminder appears as large text on the screen and can be customized through the addon's settings.

You can configure:

- Reminder text.
- Font size.
- Display duration.
- Fade-out duration.
- Reminder position.
- Reminder sound.
- World notifications.

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
| `/tr instances` | Prints dungeons, raids and Delves grouped by expansion. |
| `/tr instances delves` | Shows detected The War Within and Midnight Delves. Use `/tr id` inside a Delve to get its real InstanceID. |
| `/tr instances classic` | Shows Classic only. |
| `/tr instances tbc` | Shows The Burning Crusade only. |
| `/tr instances wotlk` | Shows Wrath of the Lich King only. |
| `/tr instances cata` | Shows Cataclysm only. |
| `/tr instances mop` | Shows Mists of Pandaria only. |
| `/tr instances wod` | Shows Warlords of Draenor only. |
| `/tr instances legion` | Shows Legion only. |
| `/tr instances bfa` | Shows Battle for Azeroth only. |
| `/tr instances shadowlands` | Shows Shadowlands only. |
| `/tr instances dragonflight` | Shows Dragonflight only. |
| `/tr instances tww` | Shows The War Within only. |
| `/tr instances midnight` | Shows Midnight only. |


### Estructura interna / Internal structure

`Core/Instances.lua` contiene únicamente la lógica utilizada por Talent Reminder para determinar si una `instanceID` está configurada o se considera Mundo.

`Tools/InstanceDump.lua` contiene la herramienta de diagnóstico utilizada por `/tr instances`, incluyendo el recorrido por expansiones, mazmorras, bandas y Delves.

`Core/Instances.lua` only contains the runtime logic used by Talent Reminder to determine whether an `instanceID` is tracked or considered World.

`Tools/InstanceDump.lua` contains the `/tr instances` diagnostic utility, including expansion, dungeon, raid and Delve enumeration.
