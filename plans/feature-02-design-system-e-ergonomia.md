# Feature Plan: 02 - Design System, Paleta de Cores e Ergonomia de Mesa

> Baseado na Seção 2 (Design System e Identidade Visual Inspirada em Fábula TCG) de `plans/roadmap.md`.

## 1. Visão Geral
Construir o Design System e biblioteca de componentes visuais do aplicativo com base nas 7 cores oficiais de cartas/bases de Fábula TCG e nos requisitos de ergonomia de mesa (legibilidade à distância, suporte a rotação 180°, modos webcam/stream e acessibilidade).

## 2. Paleta Oficial de Fábula TCG e Tokens de UI
| Cor Oficial | Aplicação na UI | Uso no Jogo |
| :--- | :--- | :--- |
| **Branco** | Botões primários, marcadores neutros e bordas de seleção ativa | Base / Cartas Brancas |
| **Azul** | Indicadores de fases do turno, cabeçalhos de estatísticas, navegação | Base / Cartas Azuis |
| **Amarelo** | Destaque do contador de recursos e marcadores de prioridade | Base / Cartas Amarelas |
| **Verde** | Indicadores de vida, marcadores de restauração, saúde dos aliados | Base / Cartas Verdes |
| **Vermelho**| Botões de dano, destruição e alertas da subfase de Ofensiva | Base / Cartas Vermelhas |
| **Roxo** | Marcadores da subfase de Influência, alteração de controle | Base / Cartas Roxas |
| **Incolor** | Fundos neutros, divisores de interface e cartões desativados | Incolor e estrutura UI |

## 3. Ergonomia e Acessibilidade
- **Visibilidade à Distância**: Tipografia grande (headline/display) com contraste elevado para leitura dos dois lados da mesa.
- **Wakelock (Trava de Tela)**: Integração com pacote nativo (ex: `wakelock_plus`) para impedir bloqueio de tela por inatividade durante a partida.
- **Acessibilidade**: Modos de alto contraste, contraste invertido, escala de cinza e suporte a fontes com maior legibilidade para dislexia.
- **Layouts de Mesa**:
  - Modo 2 jogadores frente a frente (rotação de 180° para o oponente).
  - Modo Stream / Webcam (interface limpa, focada em captura de vídeo).
  - Auto-ocultamento de menus e botões secundários durante o combate.

## 4. Tarefas de Implementação

### 4.1. Tokens de Tema e Cores
- [ ] Implementar classe de constantes/tokens de cores: `FabulaColors` (White, Blue, Yellow, Green, Red, Purple, Colorless).
- [ ] Configurar `ThemeData` claro/escuro com tipografia dimensionada para leitura em distância de mesa (`FabulaTypography`).
- [ ] Criar gerenciador de temas no Riverpod (`themeModeProvider`, `accessibilitySettingsProvider`).

### 4.2. Componentes Base de UI
- [ ] Criar botões numéricos com feedback háptico e animação de toque (`CounterButton`, `IncrementDecrementPill`).
- [ ] Criar widgets de marcadores com alto contraste e identificação visual de cor (`TerritoryBadge`, `PhaseChip`).
- [ ] Implementar container rotacionável (`RotatablePlayerZone`) para suportar visualização espelhada (180°).

### 4.3. Ergonomia de Mesa e WakeLock
- [ ] Adicionar e configurar ativação de `wakelock_plus` durante telas de jogo ativas.
- [ ] Criar toggle para o "Modo Stream / Webcam" (oculta overlays desnecessários e expande números centrais).
- [ ] Criar modos de acessibilidade (Alto Contraste / Monocromático).

## 5. Critérios de Aceite
- [ ] Cores oficiais mapeadas fielmente às regras do jogo.
- [ ] Números de contagem legíveis a pelo menos 1 metro de distância em telas mobile comuns.
- [ ] Rotação de 180° funcional e reativa sem corte de elementos.
- [ ] Tela permanece ativa durante toda a partida ativa.
