# Chore 01: Brasofuturismo Design System

> Emulação fiel da experiência visual e identidade do site oficial [fabulatcg.com.br](https://fabulatcg.com.br/).

## 1. Visão Geral
Implementação do Design System completo para o aplicativo companion do Fábula TCG, fundamentado na estética **Brasofuturista** (fusão de solarpunk, cyberagreste e amazofuturismo).

## 2. Paleta Oficial Extraída (fabulatcg.com.br)
| Token | Valor Hex | Descrição / Origem |
| :--- | :--- | :--- |
| `surfaceDark` | `#111111` | Fundo sólido principal escuro (`--wp--preset--color--contrast`) |
| `surfaceElevated` | `#1A1A1A` | Superfície sólida de cartões e módulos |
| `surfaceOverlay` | `#242424` | Superfície elevada (toolbar, diálogos, menus) |
| `border` | `#333333` | Bordas e divisores estruturais |
| `surfaceLight` | `#F9F9F9` | Fundo sólido do tema claro (`--wp--preset--color--base`) |
| `white` | `#FFFFFF` | Branco neutro (`--wp--preset--color--base-2`) |
| `blue` | `#0693E3` | Azul oficial (`--wp--preset--color--vivid-cyan-blue`) |
| `yellow` | `#F4BB61` | Ouro quente / Âmbar (`--wp--preset--color--accent-5`) |
| `green` | `#1C825B` | Verde floresta (`--wp--preset--color--accent`) |
| `red` | `#CF2E2E` | Vermelho vívido (`--wp--preset--color--vivid-red`) |
| `purple` | `#9B51E0` | Roxo místico (`--wp--preset--color--vivid-purple`) |
| `colorless` | `#636363` | Cinza neutro (`--wp--preset--color--contrast-2`) |
| `jungleGreen` | `#00473E` | Verde mata profundo (`--wp--preset--color--accent-4`) |
| `navyBlue` | `#04194E` | Azul noturno profundo (seções de destaque) |
| `goldenSand` | `#FDEA8E` | Areia dourada (`--wp--preset--color--accent-2`) |
| `terracotta` | `#D8613C` | Terracota quente (`--wp--preset--color--accent-3`) |
| `mint` | `#E5FFD3` | Menta suave (`inline light accent`) |
| `deepPurple` | `#720EEC` | Roxo intenso (`--wc--primary`) |
| `teal` | `#31CDCF` | Ciano tecnológico (`gradiente nightshade`) |

## 3. Tipografia
- Fonte primária: **Lexend** (conforme website oficial)
- Fallback: **Inter**, **Roboto**, `sans-serif`
- Escala de alta legibilidade para mesa (1+ metro de distância)

## 4. Gradientes e Efeitos de Brilho
- `nightshade`: Roxo profundo (`#330968`) ao Ciano (`#31CDCF`)
- `purpleCrush`: Ciano (`#34E2E4`) -> Azul elétrico (`#4721FB`) -> Magenta (`#AB1DFE`)
- `golden`: Dourado (`#F4BB61`) ao Areia Dourada (`#FDEA8E`)
- `restoration`: Ação de restauração (`#1C825B` ao `#31CDCF`)
- `destructive`: Ação de ofensiva/dano (`#D8613C` ao `#CF2E2E`)

## 5. Componentes Primitivos
- `FabulaCard`: Cartão sólido escuro com bordas nítidas e brilho contextual opcional.
- `FabulaGradientButton`: Botão de ação primária com gradientes temáticos e haptic feedback.
- `FabulaDivider`: Linha divisória com desvanecimento suave.
- `FabulaGlowContainer`: Envoltório atmosférico para alertas e destaque de status.
