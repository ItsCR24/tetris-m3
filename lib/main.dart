import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'board.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<bool> nothingOScolorscheme = ValueNotifier(false);

ColorScheme _applyRoleOverrides(ColorScheme scheme, {required bool isDark}) {
  return scheme.copyWith(
    surface: isDark ? const Color(0x00000000) : const Color(0xFFF1F1F1),
    surfaceContainer: isDark ? const Color(0xFF1B1B1B) : const Color(0xFFFFFFFF),
    onSecondaryContainer: const Color(0xFFD71921),
    secondaryContainer: isDark ? const Color(0xFF303030) : const Color(0xFFF1F1F1),
    primary: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1B1B1B),
    primaryContainer: isDark ? const Color(0xFF1B1B1B) : const Color(0xFF1B1B1B),
    onPrimaryContainer: const Color(0xFFFFFFFF),
  );
}

(ColorScheme light, ColorScheme dark) _generateDynamicColourSchemes(
  ColorScheme lightDynamic,
  ColorScheme darkDynamic,
) {
  var lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
  var darkBase = ColorScheme.fromSeed(
    seedColor: darkDynamic.primary,
    brightness: Brightness.dark,
  );

  var lightAdditionalColours = _extractAdditionalColours(lightBase);
  var darkAdditionalColours = _extractAdditionalColours(darkBase);

  var lightScheme = _insertAdditionalColours(lightBase, lightAdditionalColours);
  var darkScheme = _insertAdditionalColours(darkBase, darkAdditionalColours);

  return (lightScheme.harmonized(), darkScheme.harmonized());
}

List<Color> _extractAdditionalColours(ColorScheme scheme) => [
      scheme.surface,
      scheme.surfaceDim,
      scheme.surfaceBright,
      scheme.surfaceContainerLowest,
      scheme.surfaceContainerLow,
      scheme.surfaceContainer,
      scheme.surfaceContainerHigh,
      scheme.surfaceContainerHighest,
    ];

ColorScheme _insertAdditionalColours(
  ColorScheme scheme,
  List<Color> additionalColours,
) =>
    scheme.copyWith(
      surface: additionalColours[0],
      surfaceDim: additionalColours[1],
      surfaceBright: additionalColours[2],
      surfaceContainerLowest: additionalColours[3],
      surfaceContainerLow: additionalColours[4],
      surfaceContainer: additionalColours[5],
      surfaceContainerHigh: additionalColours[6],
      surfaceContainerHighest: additionalColours[7],
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: nothingOScolorscheme,
      builder: (context, isNothingOS, _) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              // Use dynamic colors if available
              final (light, dark) =
                  _generateDynamicColourSchemes(lightDynamic, darkDynamic);
              lightColorScheme = light;
              darkColorScheme = dark;
            } else {
              // Fallback to default color schemes
              lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              );
            }

            if (isNothingOS) {
              lightColorScheme = _applyRoleOverrides(lightColorScheme, isDark: false);
              darkColorScheme = _applyRoleOverrides(darkColorScheme, isDark: true);
            }

            return MaterialApp(
              title: 'Tetris M3',
              theme: ThemeData(
                colorScheme: lightColorScheme,
                fontFamily: isNothingOS ? 'Ndot57' : null,
                dialogTheme: DialogThemeData(
                  titleTextStyle: ThemeData.light().textTheme.titleLarge?.copyWith(
                    fontFamily: isNothingOS ? 'Ndot57' : null,
                  ),
                  contentTextStyle: ThemeData.light().textTheme.bodyMedium?.copyWith(
                    fontFamily: isNothingOS ? 'Ndot57' : null,
                  ),
                ),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
                  },
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                fontFamily: isNothingOS ? 'Ndot57' : null,
                dialogTheme: DialogThemeData(
                  titleTextStyle: ThemeData.dark().textTheme.titleLarge?.copyWith(
                    fontFamily: isNothingOS ? 'Ndot57' : null,
                  ),
                  contentTextStyle: ThemeData.dark().textTheme.bodyMedium?.copyWith(
                    fontFamily: isNothingOS ? 'Ndot57' : null,
                  ),
                ),
              ),
              themeMode: ThemeMode.system,
              home: GameBoard(),
            );
          },
        );
      },
    );
  }
}