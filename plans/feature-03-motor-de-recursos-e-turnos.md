# Feature Plan: 03 - Motor de Recursos e Turnos (MVP Core)

> Baseado na Seção 4.1 (Mecanismo e Regras de Recursos) e Seção 5.1 de `plans/roadmap.md` e regras invioláveis em `AGENTS.md`.

## 1. Visão Geral
Implementar o motor de regras e estado de recursos por jogador em Fábula TCG, garantindo a lógica exata de progressão por turnos, retenção para Manobras e Restauração periódica.

## 2. Regras de Negócio Invioláveis
- **Regra 1.7.2c / 1.18.10 (Progressão de Recursos)**:
  - Turno 1 = 2 Recursos Máximos.
  - A cada novo turno do jogador: Limite Máximo incrementa em +2 pontos.
  - Teto padrão = 10 Recursos Máximos (salvo modificadores de cartas).
- **Regra 1.7.3 (Recursos entre Turnos / Manobras)**:
  - Recursos não gastos no turno ativo permanecem utilizáveis durante o turno do oponente para pagar Manobras e efeitos instantâneos.
- **Regra 1.7.2b / 1.18.9 (Restauração e Limpeza)**:
  - Na Fase de Restauração do turno ativo do jogador: recursos remanescentes do turno anterior são zerados e o recurso atual é restaurado para o valor máximo do turno corrente.
- **Valores Inteiros Não-Negativos (Regra 1.8.1)**:
  - Recursos nunca podem assumir valores negativos.

## 3. Design de Estado (Domain & Riverpod)
```dart
class ResourceState {
  final int currentResources;
  final int maxResources;
  final int turnNumber;
  final int resourceCap; // Padrão: 10
}
```

## 4. Tarefas de Implementação

### 4.1. Camada de Domínio (Pure Rules & Logic)
- [ ] Criar entidade imutável `ResourceState`.
- [ ] Criar controlador/notifier de regras `ResourceNotifier` / `ResourceController`:
  - `startMatch()`: Inicializa Turno 1 com 2 Recursos Max e 2 Recursos Atuais.
  - `spendResources(int amount)`: Deduz recursos com validação contra saldo insuficiente e impedindo valores negativos.
  - `gainBonusResources(int amount)`: Adiciona recursos temporários/efeitos imediatos.
  - `modifyMaxResourcesCap(int newCap)`: Suporte para efeitos de cartas que alteram teto.
  - `advanceToNextTurn(PlayerId nextActivePlayer)`:
    - Incrementa turno do jogador.
    - Se for início de turno ativo deste jogador: reseta saldo anterior e restaura para o novo `maxResources` (+2, max 10).
    - Se for início do turno do oponente: mantém saldo restante disponível para Manobras.

### 4.2. Camada de Apresentação
- [ ] Desenvolver widget `ResourceCounterWidget`:
  - Destaque amarelo oficial para contadores de recursos.
  - Botões rápidos de incremento/decremento (-1, +1, -X).
  - Indicador de Recursos Disponíveis vs Recursos Máximos (`current / max`).
  - Botão de ação rápida "Restaurar" (reseta current = max).

### 4.3. Testes Unitários Estritos (Obrigatório conforme `AGENTS.md`)
- [ ] Teste: Turno 1 inicia com 2 max e 2 current.
- [ ] Teste: Turno 2 incrementa para 4 max e restaura.
- [ ] Teste: Progressão até o teto de 10 max nos turnos subsequentes.
- [ ] Teste: Tentativa de gastar mais recursos do que o saldo lança erro ou impede ação.
- [ ] Teste: Recursos remanescentes persistem no turno do oponente para uso com Manobras.
- [ ] Teste: Fase de restauração zera sobra anterior e restaura o novo teto.

## 5. Critérios de Aceite
- [ ] 100% de cobertura de testes unitários para toda lógica de cálculo e progressão de recursos.
- [ ] Imutabilidade estrita respeitada na camada de domínio.
- [ ] Interface reativa com feedback claro ao gastar ou restaurar recursos.
