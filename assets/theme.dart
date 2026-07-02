// =============================================================================
// THEME.DART
// -----------------------------------------------------------------------------
// Système de design Flutter équivalent à `styles_2.css`.
// Centralise couleurs, espacements, rayons, ombres, dégradés, typographies
// et un ThemeData global, pour que toutes tes apps Flutter partagent
// l'identité visuelle "violet / rouge néon" du site CSS d'origine.
//
// SOMMAIRE
//   1. AppColors       – équivalent des variables couleur du :root
//   2. AppGradients    – dégradés réutilisés (header, footer, boutons...)
//   3. AppSpacing       – équivalent --spacing-*
//   4. AppRadius        – équivalent --border-radius-*
//   5. AppShadows        – équivalent --shadow-*
//   6. AppDurations      – équivalent --transition-*
//   7. AppBreakpoints    – équivalent des @media (max-width: ...)
//   8. AppTypography     – police Poppins + styles de texte (h1, cartes...)
//   9. AppDecorations    – "classes CSS" prêtes à poser sur un Container
//  10. AppBackground     – widget pour reproduire le fond dégradé du <body>
//  11. AppTheme          – ThemeData global à brancher sur MaterialApp
//
// POLICE
//   Le CSS utilise 'Poppins'. Pour qu'elle soit vraiment chargée dans Flutter,
//   ajoute le package google_fonts à ton pubspec.yaml :
//       dependencies:
//         google_fonts: ^6.2.1
//   puis remplace les TextStyle(fontFamily: 'Poppins', ...) ci-dessous par
//   GoogleFonts.poppins(...). Sans ça, Flutter retombera sur la police
//   système (l'app fonctionnera, juste avec une police différente).
//
// UTILISATION RAPIDE
//   MaterialApp(
//     theme: AppTheme.themeData,
//     home: const MaPage(),
//   )
//
//   Scaffold(
//     body: AppBackground(            // reproduit le fond dégradé du <body>
//       child: Container(
//         decoration: AppDecorations.card,   // équivalent de .card
//         child: ...,
//       ),
//     ),
//   )
// =============================================================================

import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// 1. COULEURS — équivalent de :root { --primary-purple: ...; }
// -----------------------------------------------------------------------------
/// Palette de couleurs de l'application.
///
/// ⚠️ Certains noms viennent tels quels du CSS d'origine, qui contenait déjà
/// des incohérences (ex. `--primary-blue` vaut en réalité un rouge, suite à
/// un remplacement de couleurs jamais finalisé). Les noms sont conservés
/// pour rester 1:1 avec le CSS ; seule la valeur compte vraiment.
class AppColors {
  AppColors._();

  // Couleurs principales
  static const Color primaryPurple = Color(0xFFBF00FF);
  static const Color secondaryPurple = Color(0xFF6614B8);

  /// ⚠️ Nommée "blue" dans le CSS, mais la valeur réelle est un rouge.
  static const Color primaryBlue = Color(0xFFE60000);

  /// ⚠️ Nommée "blue" dans le CSS, mais la valeur réelle est un rouge.
  static const Color secondaryBlue = Color(0xFFFF0000);

  /// ⚠️ Nommée "teal" dans le CSS, mais la valeur réelle est un rouge.
  static const Color accentTeal = Color(0xFFFF0000);

  static const Color accentGold = Color(0xFFFFD700);

  // Texte & neutres
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFF333333);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyLight = Color(0xFFC0C0C0);
  static const Color greyDark = Color(0xFFA0A0A0);

  static const Color linkColor = textLight;
  static const Color hoverLinkColor = accentGold;

  // Couleurs ponctuelles utilisées telles quelles dans le CSS d'origine
  static const Color navBarRed = Color(0xFFD51818); // fond .main-nav + ombres boutons
  static const Color darkRed = Color(0xFF9B2222); // ombre nav-link.current-page, hover glossaire
  static const Color tealHover1 = Color(0xFF00A0B8); // hover .primary-button (début)
  static const Color tealHover2 = Color(0xFF00849C); // hover .primary-button (fin)
  static const Color purpleDark1 = Color(0xFF501090); // .secondary-button (fin) / glossaire hover (début)
  static const Color purpleDark2 = Color(0xFF3A0B6B); // hover .secondary-button (fin)
  static const Color purpleBorder = Color(0xFF7A25D1); // bordure .secondary-button / #searchInput
  static const Color redHover1 = Color(0xFF863838); // hover bouton recherche (début)
  static const Color redHover2 = Color(0xFFB33A3A); // hover bouton recherche (fin)
  static const Color cssPurple = Color(0xFF800080); // couleur nommée "purple" en CSS
}

// -----------------------------------------------------------------------------
// 2. DÉGRADÉS — équivalent des linear-gradient(...)
// -----------------------------------------------------------------------------
/// Dégradés réutilisés sur le header, le footer, les boutons, etc.
class AppGradients {
  AppGradients._();

  /// Fond du <body> : violet -> rouge, en diagonale.
  static const LinearGradient bodyBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryPurple, AppColors.primaryBlue],
  );

  /// .main-header et .main-footer.
  static const LinearGradient headerFooter = LinearGradient(
    colors: [AppColors.secondaryPurple, AppColors.secondaryBlue],
  );

  /// .primary-button (état normal).
  static const LinearGradient primaryButton = LinearGradient(
    colors: [AppColors.accentTeal, AppColors.cssPurple],
  );

  /// .primary-button:hover.
  static const LinearGradient primaryButtonHover = LinearGradient(
    colors: [AppColors.tealHover1, AppColors.tealHover2],
  );

  /// .secondary-button (état normal).
  static const LinearGradient secondaryButton = LinearGradient(
    colors: [AppColors.primaryPurple, AppColors.purpleDark1],
  );

  /// .secondary-button:hover.
  static const LinearGradient secondaryButtonHover = LinearGradient(
    colors: [AppColors.purpleDark1, AppColors.purpleDark2],
  );

  /// details.glossaire summary (état normal).
  static const LinearGradient glossarySummary = LinearGradient(
    colors: [AppColors.primaryPurple, AppColors.primaryBlue],
  );

  /// details.glossaire summary:hover.
  static const LinearGradient glossarySummaryHover = LinearGradient(
    colors: [AppColors.purpleDark1, AppColors.darkRed],
  );

  /// Bouton de la barre de recherche (état normal).
  static const LinearGradient searchButton = LinearGradient(
    colors: [AppColors.accentTeal, AppColors.darkRed],
  );

  /// Bouton de la barre de recherche (hover).
  static const LinearGradient searchButtonHover = LinearGradient(
    colors: [AppColors.redHover1, AppColors.redHover2],
  );
}

// -----------------------------------------------------------------------------
// 3. ESPACEMENTS — équivalent --spacing-*
// -----------------------------------------------------------------------------
/// Échelle d'espacement (paddings, margins, gaps...).
class AppSpacing {
  AppSpacing._();

  static const double xs = 5;
  static const double s = 10;
  static const double m = 15;
  static const double l = 20;
  static const double xl = 25;
  static const double xxl = 30;
  static const double xxxl = 40;
}

// -----------------------------------------------------------------------------
// 4. RAYONS DE BORDURE — équivalent --border-radius-*
// -----------------------------------------------------------------------------
/// Échelle de border-radius.
class AppRadius {
  AppRadius._();

  static const double small = 3;
  static const double medium = 8;
  static const double large = 10;
  static const double pill = 30;
  static const double button = 25;

  /// Équivalent de 50% en CSS : utilise BorderRadius.circular(AppRadius.circular)
  /// ou directement un ClipOval/CircleAvatar pour un cercle parfait.
  static const double circular = 9999;
}

// -----------------------------------------------------------------------------
// 5. OMBRES — équivalent --shadow-*
// -----------------------------------------------------------------------------
/// Ombres prêtes à l'emploi (à passer dans `boxShadow:` d'une BoxDecoration).
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get small => [
        const BoxShadow(color: AppColors.navBarRed, blurRadius: 10),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(2, 4),
        ),
      ];

  static List<BoxShadow> get strong => [
        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20),
      ];

  static List<BoxShadow> get button => [
        const BoxShadow(
          color: AppColors.navBarRed,
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ];

  static List<BoxShadow> get buttonHover => [
        const BoxShadow(
          color: AppColors.navBarRed,
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get secondaryButton => [
        BoxShadow(
          color: AppColors.secondaryPurple.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ];

  static List<BoxShadow> get secondaryButtonHover => [
        BoxShadow(
          color: AppColors.secondaryPurple.withOpacity(0.6),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get logo => [
        BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 15),
      ];
}

// -----------------------------------------------------------------------------
// 6. DURÉES / COURBES — équivalent --transition-*
// -----------------------------------------------------------------------------
/// Durées et courbes d'animation, pour AnimatedContainer, AnimatedOpacity, etc.
class AppDurations {
  AppDurations._();

  static const Duration normal = Duration(milliseconds: 300);
  static const Duration fast = Duration(milliseconds: 200);

  /// Équivalent de la courbe CSS "ease".
  static const Curve curve = Curves.easeInOut;
}

// -----------------------------------------------------------------------------
// 7. BREAKPOINTS — équivalent des @media (max-width: ...)
// -----------------------------------------------------------------------------
/// Largeurs de référence pour adapter les layouts (cf. les media queries CSS).
class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 992;
  static const double mobile = 768;
  static const double smallMobile = 480;
}

/// Permet d'écrire `context.isMobile` plutôt que de relire MediaQuery partout.
extension AppResponsive on BuildContext {
  double get _screenWidth => MediaQuery.sizeOf(this).width;

  bool get isTablet => _screenWidth <= AppBreakpoints.tablet;
  bool get isMobile => _screenWidth <= AppBreakpoints.mobile;
  bool get isSmallMobile => _screenWidth <= AppBreakpoints.smallMobile;
}

// -----------------------------------------------------------------------------
// 8. TYPOGRAPHIE — police Poppins + styles de texte
// -----------------------------------------------------------------------------
/// Styles de texte correspondant aux différents éléments du CSS
/// (h1, .site-slogan, .card-body h4, .footer-section h3, etc.)
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Poppins';

  /// .main-header h1
  static const TextStyle headerTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 2,
    shadows: [
      Shadow(offset: Offset(2, 2), blurRadius: 4, color: Color(0x80000000)),
    ],
  );

  /// .site-slogan
  static const TextStyle siteSlogan = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: Color(0xE6FFFFFF), // blanc à 90% d'opacité
  );

  /// .main-content h2 / h3
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.accentTeal,
    shadows: [
      Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color(0x4D000000)),
    ],
  );

  /// .intro-section p
  static const TextStyle introText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    color: AppColors.textLight,
    height: 1.6,
  );

  /// .nav-link
  static const TextStyle navLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  /// .nav-link:hover / :focus
  static const TextStyle navLinkHover = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.accentGold,
  );

  /// .button (texte des boutons primary/secondary)
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  /// .small-button
  static const TextStyle smallButtonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  /// .card-body h4
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.accentGold,
  );

  /// .card-body p
  static const TextStyle cardBody = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    color: AppColors.greyLight,
  );

  /// .footer-section h3
  static const TextStyle footerTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: AppColors.accentTeal,
  );

  /// .footer-section ul li a
  static const TextStyle footerLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    color: AppColors.linkColor,
  );

  /// .copyright
  static const TextStyle copyright = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.greyDark,
  );

  /// .glossaire-content dt
  static const TextStyle glossaryTerm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.8,
    fontWeight: FontWeight.bold,
    color: AppColors.accentGold,
  );

  /// .glossaire-content dd
  static const TextStyle glossaryDefinition = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    color: AppColors.greyLight,
  );

  /// .highlight (texte ; à combiner avec AppDecorations.highlight pour le fond)
  static const TextStyle highlight = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textDark,
    fontWeight: FontWeight.w600,
  );

  /// body (texte par défaut)
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.textLight,
    height: 1.6,
  );

  /// Mappe ces styles sur les slots Material 3 (Text() les utilisera
  /// automatiquement une fois AppTheme.themeData appliqué).
  static TextTheme get textTheme => const TextTheme(
        displayLarge: headerTitle,
        headlineMedium: sectionTitle,
        titleLarge: footerTitle,
        titleMedium: cardTitle,
        bodyLarge: introText,
        bodyMedium: body,
        bodySmall: cardBody,
        labelLarge: buttonLabel,
        labelMedium: navLink,
        labelSmall: copyright,
      );
}

// -----------------------------------------------------------------------------
// 9. DÉCORATIONS — équivalent direct des classes CSS (.card, .button, etc.)
// -----------------------------------------------------------------------------
/// "Classes CSS" prêtes à l'emploi : à passer dans `decoration:` d'un Container.
///
/// Exemple :
///   Container(
///     padding: const EdgeInsets.all(AppSpacing.m),
///     decoration: AppDecorations.card,
///     child: ...,
///   )
class AppDecorations {
  AppDecorations._();

  /// .main-header
  static BoxDecoration get header => BoxDecoration(
        gradient: AppGradients.headerFooter,
        boxShadow: AppShadows.medium,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.medium),
          bottomRight: Radius.circular(AppRadius.medium),
        ),
      );

  /// .main-footer
  static BoxDecoration get footer => BoxDecoration(
        gradient: AppGradients.headerFooter,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.medium),
          topRight: Radius.circular(AppRadius.medium),
        ),
      );

  /// .logo (à poser autour d'un ClipOval contenant l'image)
  static BoxDecoration get logo => BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.logo,
      );

  /// .main-content
  static BoxDecoration get mainContent => BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.strong,
      );

  /// .card
  static BoxDecoration get card => BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.card,
      );

  /// .card:hover
  static BoxDecoration get cardHovered => BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.cardHover,
      );

  /// .primary-button
  static BoxDecoration get primaryButton => BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.button,
      );

  /// .primary-button:hover
  static BoxDecoration get primaryButtonHovered => BoxDecoration(
        gradient: AppGradients.primaryButtonHover,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.buttonHover,
      );

  /// .secondary-button
  static BoxDecoration get secondaryButton => BoxDecoration(
        gradient: AppGradients.secondaryButton,
        border: Border.all(color: AppColors.purpleBorder),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.secondaryButton,
      );

  /// .secondary-button:hover
  static BoxDecoration get secondaryButtonHovered => BoxDecoration(
        gradient: AppGradients.secondaryButtonHover,
        border: Border.all(color: AppColors.purpleBorder),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.secondaryButtonHover,
      );

  /// .small-button
  static BoxDecoration get smallButton => BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      );

  /// .small-button:hover
  static BoxDecoration get smallButtonHovered => BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      );

  /// .nav-link:hover / :focus (fond)
  static BoxDecoration get navLinkHovered => BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.small),
      );

  /// .nav-link.current-page
  static BoxDecoration get navLinkActive => BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.circular(AppRadius.small),
        boxShadow: [BoxShadow(color: AppColors.darkRed, blurRadius: 10)],
      );

  /// details.glossaire summary
  static BoxDecoration get glossarySummary => BoxDecoration(
        gradient: AppGradients.glossarySummary,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      );

  /// details.glossaire summary:hover
  static BoxDecoration get glossarySummaryHovered => BoxDecoration(
        gradient: AppGradients.glossarySummaryHover,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      );

  /// .glossaire-content
  static BoxDecoration get glossaryContent => BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.medium),
          bottomRight: Radius.circular(AppRadius.medium),
        ),
      );

  /// #searchInput
  static BoxDecoration get searchInput => BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: AppColors.purpleBorder),
        borderRadius: BorderRadius.circular(AppRadius.button),
      );

  /// #searchInput:focus
  static BoxDecoration get searchInputFocused => BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: AppColors.accentTeal),
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: AppShadows.small,
      );

  /// .search-container button
  static BoxDecoration get searchButton => BoxDecoration(
        gradient: AppGradients.searchButton,
        borderRadius: BorderRadius.circular(AppRadius.button),
      );

  /// .search-container button:hover
  static BoxDecoration get searchButtonHovered => BoxDecoration(
        gradient: AppGradients.searchButtonHover,
        borderRadius: BorderRadius.circular(AppRadius.button),
      );

  /// .highlight (fond ; à combiner avec AppTypography.highlight pour le texte)
  static BoxDecoration get highlight => BoxDecoration(
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(AppRadius.small),
      );

  /// .image-container
  static BoxDecoration get imageContainer => BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// .content-image
  /// (le float left/right du CSS est une question de layout : utilise un
  /// Row, un Align ou un Wrap autour du widget plutôt qu'une décoration.)
  static BoxDecoration get contentImage => BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppShadows.card,
      );
}

// -----------------------------------------------------------------------------
// 10. FOND DÉGRADÉ — équivalent du background du <body>
// -----------------------------------------------------------------------------
/// Reproduit le dégradé violet -> rouge appliqué au <body> en CSS.
/// À utiliser à la place (ou autour) du body d'un Scaffold, puisqu'un
/// ThemeData ne peut pas porter de dégradé pour `scaffoldBackgroundColor`.
///
/// Exemple :
///   Scaffold(
///     body: AppBackground(child: MonContenu()),
///   )
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.bodyBackground),
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// 11. THEME DATA — à brancher sur MaterialApp(theme: AppTheme.themeData)
// -----------------------------------------------------------------------------
/// ThemeData global qui branche les tokens ci-dessus sur les widgets Material
/// standards (AppBar, ElevatedButton, Card, TextField...), pour que ton app
/// soit "dans le thème" même sans poser AppDecorations.* partout à la main.
class AppTheme {
  AppTheme._();

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.secondaryPurple,
      fontFamily: AppTypography.fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        onPrimary: AppColors.white,
        secondary: AppColors.accentTeal,
        onSecondary: AppColors.white,
        tertiary: AppColors.accentGold,
        onTertiary: AppColors.textDark,
        surface: AppColors.secondaryPurple,
        onSurface: AppColors.textLight,
        error: AppColors.secondaryBlue,
        onError: AppColors.white,
      ),
      textTheme: AppTypography.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headerTitle,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        // .primary-button
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.buttonLabel,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          elevation: 6,
          shadowColor: AppColors.navBarRed,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        // .secondary-button
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: AppTypography.buttonLabel,
          side: const BorderSide(color: AppColors.purpleBorder),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        // .nav-link
        style: TextButton.styleFrom(
          foregroundColor: AppColors.hoverLinkColor,
          textStyle: AppTypography.navLink,
        ),
      ),
      cardTheme: CardThemeData(
        // .card — sur Flutter < 3.27, remplace par `CardTheme`
        color: Colors.white.withOpacity(0.05),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.large)),
        margin: const EdgeInsets.all(AppSpacing.s),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // #searchInput
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintStyle: const TextStyle(color: AppColors.greyDark, fontFamily: AppTypography.fontFamily),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.purpleBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.purpleBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x1AFFFFFF), // blanc à 10% d'opacité
        thickness: 1,
        space: AppSpacing.l,
      ),
      iconTheme: const IconThemeData(color: AppColors.textLight),
    );
  }
}