# RTS Moba Flame

RTS móvil 2D (top-down) con **Flutter + Flame**. UI en **español**. v0.1 = construcción y recolección (sin combate real ni MOBA).

Repo: [GerardoRosas-27/rts-moba-flame](https://github.com/GerardoRosas-27/rts-moba-flame)

## Cómo jugar (v0.1)

1. Empiezas con **1 Centro de Mando** y **5 obreros**, **150 minerales**.
2. **Toca** un obrero (o varios vía grupos) para seleccionarlo.
3. Toca un **cristal azul** → el obrero recolecta, lleva al CC y **repite** solo.
4. **CONSTRUIR → Refinería** sobre el géiser verde → luego recolecta **gas**.
5. Selecciona el **Centro de Mando** → entrena más **Obreros** (cuesta minerales + suministro).
6. Construye **Depósito** para más suministro; **Puesto avanzado** / **Centro de Mando** para expandir.
7. **Arrastra** para panear la cámara; **pellizca** o botones +/- para zoom.
8. Grupos 1–4: **mantener** para asignar, **tocar** para recuperar.

Comandos: **MOVER** (toca el mapa), **MANTENER**, **CONSTRUIR**. ATACAR / PATRULLA / ESPECIAL son stubs en v0.1.

## Feel numbers (v0.1)

Documentados en `lib/game/balance.dart`:

| Parámetro | Valor |
|-----------|-------|
| Minerales iniciales | 150 |
| Obreros iniciales | 5 |
| Suministro del CC | 10 |
| Mapa | 2400 × 1800 px |
| Zoom cámara | 0.45 – 1.6 (inicio 0.85) |
| Costo obrero | 50 minerales, 1 suministro, 12 s |
| Velocidad obrero | 95 px/s |
| Carga mineral / gas | 8 / 6 |
| Tiempo de recolección | 1.6 s |
| Nodo mineral / géiser | 1500 / 2500 |
| Refinería | 100 minerales, 30 s |
| Depósito | 100 minerales, +8 suministro, 20 s |
| Cuartel | 150 minerales, 35 s (stub) |
| Puesto avanzado | 150 minerales, 40 s (depósito) |
| CC expansión | 400 minerales, 60 s, +10 suministro |
| Cola de producción | máx. 6 |

## Ejecutar

```bash
export PATH="/home/box/flutter/bin:$PATH"
export ANDROID_HOME=/home/box/Android/Sdk
cd rts-moba-flame
flutter pub get
flutter run
```

Release Android:

```bash
flutter build apk --release
```

## Estructura

```
lib/
  main.dart
  game/
    balance.dart      # feel numbers
    enums.dart
    rts_game.dart     # FlameGame + input + loop
    components/       # unidades, edificios, recursos, terreno
    systems/          # economía, cola de producción
  ui/
    hud.dart          # HUD español (minerales, gas, suministro, cola, comandos)
```

## Roadmap breve

- v0.1 — construcción + harvesting (este release)
- v0.2 — combate básico / unidades militares
- v0.3+ — capas MOBA (héroes, carriles) opcional

## Licencia

Uso privado / demo del autor salvo que se indique lo contrario.
