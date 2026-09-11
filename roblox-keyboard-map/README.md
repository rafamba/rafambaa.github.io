# Mapa interactivo: Teclado ROBUX

Scripts para Roblox Studio: un teclado gigante tirado en el piso donde
solo las teclas **R, O, B, U, X** y **Enter** se iluminan de verde al
pisarlas. El resto de las teclas no hacen nada.

## 1. Arma el teclado en Studio

1. En el **Explorer**, crea un **Folder** dentro de `Workspace` y
   llámalo exactamente `Keyboard`.
2. Adentro, mete una `Part` por cada tecla (achatada, tipo losa, tiradas
   en el piso como en las imágenes de referencia).
3. Ponle a cada `Part` el **Name** exacto de su tecla: `Q`, `W`, `E`,
   `R`, `T`, `Y`, `U`, `I`, `O`, `P`, `A`, `S`, ..., `Enter`, etc.
   - No importan mayúsculas/minúsculas, el script las normaliza.
   - Pueden agruparlas en subcarpetas (por fila, por ejemplo), el
     script las encuentra igual porque recorre todos los descendientes.
4. Solo importan los nombres `R`, `O`, `B`, `U`, `X` y `Enter` — esas
   son las que se van a iluminar. El resto puede llamarse como quieras.

## 2. Instala el script principal

1. En **ServerScriptService**, crea un `Script` nuevo.
2. Copia adentro el contenido de `KeyboardHighlighter.server.lua`.
3. Dale Play. Al pisar `R`, `O`, `B`, `U`, `X` o `Enter` esa tecla se
   pone verde con una transición suave (tween) y se queda así.

Por diseño la tecla se queda iluminada para siempre una vez pisada (para
que se vea el progreso tipo "voy completando ROBUX"), no se apaga al
bajarte. Si preferís que se apague cuando el jugador se baja de la
tecla, avisame y lo ajustamos con `TouchEnded`.

### Personalizar

Todo esto está al principio de `KeyboardHighlighter.server.lua`:

- `TARGET_KEYS`: la lista de teclas que se iluminan.
- `LIT_COLOR`: el color verde (`Color3.fromRGB(0, 255, 0)`).
- `TWEEN_INFO`: qué tan rápido/con qué curva cambia el color.

## 3. Entorno (opcional)

`EnvironmentSetup.server.lua` genera automáticamente:

- El **Baseplate** en pasto verde.
- Un **camino de asfalto** gris hacia el teclado.
- Unos **árboles** low-poly de decoración alrededor.

Instalación: igual que el anterior, un `Script` nuevo en
`ServerScriptService` con ese contenido. Es seguro dejarlo puesto: solo
construye una vez y no duplica nada en los siguientes arranques.

Las posiciones de la calle y los árboles son un punto de partida —
ajustalas en el script (o movelas a mano en Studio después de que se
generen) según el tamaño y la orientación real de tu teclado. Si
después querés algo más elaborado (bancas, luces, globos como en tus
videos de referencia) lo vamos agregando.
