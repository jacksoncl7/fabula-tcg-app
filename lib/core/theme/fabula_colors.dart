import 'package:material_ui/material_ui.dart';

/// Official Brasofuturist color palette for Fábula TCG.
///
/// Colors extracted directly from fabulatcg.com.br CSS custom properties
/// (`--wp--preset--color--*`, `--wc--*`, inline styles).
abstract final class FabulaColors {
  // ─── Brand Primaries (Card Identity Colors & Tabletop Rules) ───

  /// White: Primary buttons, neutral counters, active selection borders.
  /// Source: `--wp--preset--color--base-2` (#ffffff)
  static const Color white = Color(0xFFFFFFFF);

  /// Blue: Turn phase indicators, stats headers, navigation accents.
  /// Source: `--wp--preset--color--vivid-cyan-blue` (#0693e3)
  static const Color blue = Color(0xFF0693E3);

  /// Yellow: Resource counter highlights, priority tokens, Center base.
  /// Source: `--wp--preset--color--accent-5` (#f4bb61)
  static const Color yellow = Color(0xFFF4BB61);

  /// Green: Life points, restoration, ally health, eco-tech accents.
  /// Source: `--wp--preset--color--accent` (#1c825b)
  static const Color green = Color(0xFF1C825B);

  /// Red: Damage buttons, destruction, offensive sub-phase alerts.
  /// Source: `--wp--preset--color--vivid-red` (#cf2e2e)
  static const Color red = Color(0xFFCF2E2E);

  /// Purple: Influence markers, control shift, conquest, mystic glow.
  /// Source: `--wp--preset--color--vivid-purple` (#9b51e0)
  static const Color purple = Color(0xFF9B51E0);

  /// Colorless: Disabled elements, muted dividers.
  /// Source: `--wp--preset--color--contrast-2` (#636363)
  static const Color colorless = Color(0xFF636363);

  // ─── Surface System (Brasofuturist Dark - Solid Backgrounds) ───

  /// Deepest background — near-black (dark mode primary, solid background).
  /// Source: `--wp--preset--color--contrast` (#111111)
  static const Color surfaceDark = Color(0xFF111111);

  /// Elevated card/container solid surface.
  /// Source: inline card surface (#121212 / #1a1a1a solid)
  static const Color surfaceElevated = Color(0xFF1A1A1A);

  /// Highest elevation surface (modals, app bars, toolbar).
  static const Color surfaceOverlay = Color(0xFF242424);

  /// Structural borders and dividers.
  static const Color border = Color(0xFF333333);

  /// Light theme background.
  /// Source: `--wp--preset--color--base` (#f9f9f9)
  static const Color surfaceLight = Color(0xFFF9F9F9);

  /// Light theme elevated surface.
  /// Source: `--wp--preset--color--base-2` (#ffffff)
  static const Color surfaceLightElevated = Color(0xFFFFFFFF);

  // ─── Brasofuturist Brand Identity (Priority Colors) ───

  /// Primary Golden Yellow: Predominante no fundo direito, logotipo "FÁBULA",
  /// grafismos e destaques principais.
  static const Color brandGoldenYellow = Color(0xFFF8BD52);

  /// Primary Dark Teal Green: Predominante no fundo esquerdo e áreas internas
  /// do padrão geométrico.
  static const Color brandDarkTeal = Color(0xFF0A4038);

  /// Secondary Light Cream Yellow: Iluminação central no degradê do fundo e pontos de luz.
  static const Color brandCreamYellow = Color(0xFFFCE181);

  /// Secondary Amber Orange: Sombreamento na extremidade direita e detalhes do logotipo.
  static const Color brandAmberOrange = Color(0xFFF09E38);

  /// Secondary Deep Forest Green: Cor de texto do menu de navegação e tipografia de alto contraste.
  static const Color brandForestGreen = Color(0xFF083315);

  /// Secondary Emerald Green: Texturas, divisores e pontos de luz no fundo escuro.
  static const Color brandEmeraldGreen = Color(0xFF126B55);

  // ─── Text Hierarchy ───

  /// High-emphasis text on dark surfaces.
  /// Source: `--wp--preset--color--base` (#f9f9f9)
  static const Color textPrimary = Color(0xFFF9F9F9);

  /// Medium-emphasis text (captions, metadata).
  /// Source: `--wp--preset--color--contrast-3` (#a4a4a4)
  static const Color textSecondary = Color(0xFFA4A4A4);

  /// Disabled / placeholder text.
  /// Source: `--wp--preset--color--contrast-2` (#636363)
  static const Color textDisabled = Color(0xFF636363);

  // ─── Brasofuturist Signature Accent Tokens ───

  /// Deep jungle green — primary CTA background, brand container.
  /// Source: `--wp--preset--color--accent-4` (#00473e)
  static const Color jungleGreen = Color(0xFF00473E);

  /// Navy midnight blue — dark section background accent.
  /// Source: inline bg (#04194e)
  static const Color navyBlue = Color(0xFF04194E);

  /// Golden sand/amber — primary highlight, badges, featured.
  /// Source: `--wp--preset--color--accent-2` (#fdea8e)
  static const Color goldenSand = Color(0xFFFDEA8E);

  /// Terracotta — warm accent, alert/action.
  /// Source: `--wp--preset--color--accent-3` (#d8613c)
  static const Color terracotta = Color(0xFFD8613C);

  /// Mint/pale green — light accent background.
  /// Source: inline bg (#e5ffd3)
  static const Color mint = Color(0xFFE5FFD3);

  /// Deep purple — WooCommerce/store CTA accent.
  /// Source: `--wc--primary` (#720eec)
  static const Color deepPurple = Color(0xFF720EEC);

  /// Cyan teal — Brasofuturist nightshade gradient endpoint.
  /// Source: nightshade gradient (#31cdcf)
  static const Color teal = Color(0xFF31CDCF);

  // ─── Game State Semantic ───

  /// Positive / success feedback.
  static const Color success = Color(0xFF1C825B);

  /// Destructive / error feedback.
  static const Color error = Color(0xFFCF2E2E);

  /// Warning / attention feedback.
  static const Color warning = Color(0xFFF4BB61);
}
