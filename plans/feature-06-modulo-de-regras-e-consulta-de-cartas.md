# Feature Plan: 06 - Biblioteca de Regras e Mecanismo de Consulta de Cartas (Fase 2)

> Baseado na Seção 5.2 (Fase 2: Módulo de Regras Integrado e Consulta de Cartas) de `plans/roadmap.md`.

## 1. Visão Geral
Disponibilizar uma central de consulta offline com a íntegra do Livro de Regras e Manual Oficial de Fábula TCG, um catálogo com busca rápida de cartas e um guia didático e interativo sobre a Pilha de Efeitos (LIFO), a Regra de Ouro e a Regra de Negação.

## 2. Escopo e Funcionalidades
1. **Biblioteca de Regras Offline**:
   - Livro de Regras Oficial completo dividido por seções indexadas.
   - Busca por texto, palavras-chave e números de regras (ex.: `1.22.4a`, `4.5.3`).
2. **Catálogo e Consulta de Cartas (Offline-First)**:
   - Banco de dados embutido (ex.: JSON/SQLite local) com metadados de cartas: Nome, Custo, Cores, Tipo (Aliado, Manobra, Base, Modificação, Ficha), Ofensiva, Influência, Vida e Oracle Text.
   - Filtros por cor oficial (Branco, Azul, Amarelo, Verde, Vermelho, Roxo, Incolor), tipo e custo.
   - Leitor/scanner óptico simples (câmera) ou busca rápida por código de carta.
3. **Guia Interativo de Regras Fundamentais**:
   - **Regra de Ouro (Regra 1.1.1)**: Texto da carta tem prioridade sobre regra geral.
   - **Regra de Negação (Regra 1.1.2 / 1.1.2a)**: Efeitos negativos anulam ações permitidas.
   - **Simulador / Visualizador de Pilha LIFO (Regra 4.5.3)**: Visualização didática de inserção e resolução do último para o primeiro.
   - **Zonas de Jogo**: Explicação de Baralho, Mão, Campo, Descarte, Pilha e Degredo.
   - **Ciclo de Fichas/Tokens (Regras 1.12.7 e 3.5.2)**: Validação de que fichas enviadas a descarte/degredo deixam de existir.

## 3. Arquitetura de Dados
```dart
class CardModel {
  final String id;
  final String code;
  final String name;
  final CardColor color;
  final CardType type;
  final int resourceCost;
  final int? offensivePower;
  final int? influencePower;
  final int? life;
  final String oracleText;
  final List<String> keywords;
}

class RuleSection {
  final String id; // Ex: '1.22.4a'
  final String title;
  final String content;
  final List<String> tags;
}
```

## 4. Tarefas de Implementação

### 4.1. Camada de Dados e Modelagem
- [ ] Estruturar o dataset offline de regras oficiais de Fábula TCG em formato JSON/DB.
- [ ] Estruturar schema do catálogo de cartas com suporte a indexação e busca offline.
- [ ] Implementar repositórios de dados `RulesRepository` e `CardsRepository`.

### 4.2. Módulo de Apresentação e Telas
- [ ] Criar tela de Biblioteca de Regras com busca instantânea e navegação por índice hierárquico.
- [ ] Criar tela de Consulta de Cartas com cartões detalhados, filtros multi-critério e preview visual.
- [ ] Criar componente visual "Simulador de Pilha LIFO" (demonstrando inserção e desempilhamento).

### 4.3. Testes
- [ ] Testes de integridade do parser e busca de regras por seção/palavra-chave.
- [ ] Testes de filtragem e consulta do catálogo de cartas.

## 5. Critérios de Aceite
- [ ] Consulta de regras e cartas 100% funcional sem conexão com internet.
- [ ] Busca de termos responde em menos de 100ms.
- [ ] Explicação fiel das regras de Ouro, Negação, Fichas e resolução LIFO da pilha.
