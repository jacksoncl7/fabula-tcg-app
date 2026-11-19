# Chore 02: Simplificação do Botão e Fluxo de Disputa de Influência

> Otimização de ergonomia e agilidade na mesa física de jogo para conquista de bases por influência.

## 1. Contexto e Motivação
Na mesa física de Fábula TCG, o cálculo de influência ($\sum(\text{Ataque}) > \sum(\text{Bloqueio}) + \text{Resistência}$) já é realizado e auditado pelos próprios jogadores através de suas cartas, marcadores e efeitos de jogo.
A exigência de digitar números de influência atacante e bloqueadora em caixas de diálogo durante a partida digital adicionava atrito e lentidão desnecessários à experiência como assistente de jogo.

## 2. Mudanças Implementadas
1. **Novo Diálogo de Confirmação Rápida**:
   - Ao tocar no botão de influência (ícone de pessoas), o aplicativo exibe um diálogo simples e direto:
     - Título: **Disputa de Influência**
     - Pergunta: *"A base foi tomada por influência?"*
     - Ações: *"Cancelar"* ou *"Confirmar"*
   - A confirmação transfere imediatamente a base para o controle do oponente, marcando-a com a cor roxa e ícone de bandeira.
2. **Ergonomia Visual dos Botões de Ação de Base**:
   - O botão de **Disputa de Influência** teve seu tamanho reduzido (`iconSize: 13.0`, `padding: 3.0`) tornando-o ligeiramente menor que o botão de **Dano de Ofensiva** (`iconSize: 16.0`, `padding: 4.0`), refletindo a hierarquia de frequência de uso das ações na partida.
3. **Novo Método de Domínio**:
   - `TerritoryNotifier.conquerBase({required String baseId, required PlayerId newController})`:
     - Valida se a base pode ser alvo (Centro bloqueado caso haja arredores ativos lança `GameRuleException`, bem como bases já destruídas).
     - Atualiza o `currentController` para o jogador conquistador.

## 3. Critérios de Aceite
- [x] Remoção completa de caixas de digitação de valores numéricos de influência.
- [x] Confirmação simples por diálogo pergunta se a base foi tomada e transfere o controle ao confirmar.
- [x] Botão de influência ligeiramente menor que o botão de dano.
- [x] Regras de proteção do Centro (Rule 3.1.9) mantidas e validadas.
- [x] 100% dos testes unitários e de widget passando sem erros.
