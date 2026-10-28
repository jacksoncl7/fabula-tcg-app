# Feature Plan: 04 - Gerenciador de Território e Bases (MVP Core)

> Baseado na Seção 4.2 (Gerenciador de Bases e Pontos de Resistência) e Seção 5.1 de `plans/roadmap.md`.

## 1. Visão Geral
Gerenciar a integridade estrutural da Zona de Território dos jogadores (5 bases: 4 Arredores e 1 Centro), controlando resistência persistente, destruição por Ofensiva, conquista por disputa de Influência e a condição estrita de bloqueio e exposição do Centro.

## 2. Regras Oficiais de Bases e Território
- **Composição da Zona de Território**:
  - **4 Arredores**: 5 pontos de resistência cada.
  - **1 Centro**: 15 pontos de resistência (Capital).
- **Dano Persistente**: O dano aplicado à resistência permanece entre turnos.
- **Destruição por Ofensiva**: Quando a resistência atinge `<= 0`, a base é destruída e enviada ao Descarte.
- **Conquista por Influência (Regra 1.22.5a)**:
  - Condição de conquista: $\sum \text{Influência Atacante} > (\sum \text{Influência Bloqueadores} + \text{Resistência Atual da Base})$.
  - Se satisfeita, o controle da base é transferido ao oponente.
- **Regra Estrita de Centro Exposto (Regras 3.1.7 a 3.1.11)**:
  - O Centro só fica exposto se **todos os 4 Arredores originais** do jogador estiverem destruídos ou conquistados pelo oponente.
  - Enquanto existir ao menos 1 Arredor original sob controle do jogador, o Centro **NÃO pode** ser atacado nem influenciado (trava lógica).
  - Arredores conquistados do oponente **NÃO** protegem o Centro do jogador e nem evitam sua exposição.
  - Se um Arredor original for recuperado, o Centro deixa de estar exposto.
- **Vitória por Captura do Centro**: Se o Centro for destruído ou conquistado por influência, a partida encerra imediatamente com vitória do invasor.

## 3. Modelo de Domínio
```dart
enum BaseType { surroundings, center }

class BaseState {
  final String id;
  final BaseType type;
  final PlayerId originalOwner;
  final PlayerId currentController;
  final int currentResistance;
  final int maxResistance; // 5 para surroundings, 15 para center
  final bool isDestroyed;
}

class TerritoryState {
  final PlayerId playerId;
  final List<BaseState> bases;
  bool get isCenterExposed;
}
```

## 4. Tarefas de Implementação

### 4.1. Camada de Domínio
- [ ] Implementar entidades imutáveis `BaseState` e `TerritoryState`.
- [ ] Implementar regras em `TerritoryNotifier` / `TerritoryRules`:
  - `applyDamage(String baseId, int damageAmount)`: deduz resistência, envia para descarte ao atingir `<= 0`.
  - `resolveInfluenceContest({required String baseId, required int attackerInfluence, required int blockerInfluence})`: avalia a fórmula oficial e transfere controle se bem-sucedido.
  - `calculateCenterExposed(PlayerId playerId)`: validação estrita baseada exclusivamente nos 4 Arredores originais.
  - `validateAttackTarget(String baseId)`: bloqueia tentativas de atacar ou influenciar Centro caso não esteja exposto.
  - Verificação de condição de vitória por destruição ou controle do Centro.

### 4.2. Camada de Apresentação
- [ ] Desenvolver `TerritoryZoneWidget`:
  - Mapeamento visual das 5 bases em formato táctil de mesa.
  - 4 slots de Arredores (5 de vida) e 1 slot destacado de Centro (15 de vida).
  - Indicador de dono original vs controlador atual (para bases conquistadas).
  - Trava visual/ícone de "Escudo / Bloqueado" no Centro enquanto protegido.
  - Modal/Calculadora de Disputa de Influência para inserção rápida de influência atacante vs bloqueadora.
  - Alerta de "CENTRO EXPOSTO!" quando os 4 arredores caem.

### 4.3. Testes Unitários
- [ ] Teste de inicialização (4 Arredores com 5 de resistência, 1 Centro com 15).
- [ ] Teste de dano persistente e transição de destruição ao atingir zero.
- [ ] Teste da fórmula de Conquista por Influência (igualdade não conquista; estritamente maior conquista).
- [ ] Teste de trava do Centro: tentativa de atacar com 1+ arredor original ativo deve falhar.
- [ ] Teste de Arredores conquistados do oponente não protegendo Centro próprio.
- [ ] Teste de vitória imediata ao destruir ou capturar o Centro.

## 5. Critérios de Aceite
- [ ] Impossibilidade de violar a regra de exposição do Centro via código de domínio.
- [ ] Calculadora de influência em conformidade com a fórmula da Regra 1.22.5a.
- [ ] Testes automatizados cobrindo todos os cenários de borda.
