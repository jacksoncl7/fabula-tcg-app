Plano inicial de Implantação: Aplicativo Mobile Open-Source Fábula TCG

1. Visão Geral Executiva e Arquitetura do Sistema

1.1. Escopo e Propósito do Projeto

O objetivo central deste projeto é o desenvolvimento de um aplicativo mobile open-source construído no ecossistema Flutter/Dart, projetado para atuar como assistente de mesa e marcador de estado de jogo de alta precisão para o Fábula TCG. Desenvolvido para oferecer suporte integral a partidas presenciais e transmissões, o aplicativo garante estrita conformidade factual com o Livro de Regras e Manual Oficial do jogo. A solução elimina a necessidade de marcadores físicos e anotações manuais imprecisas, provendo utilidade prática e imediata aos jogadores mediante o controle automatizado de recursos, integridade estrutural do território, progressão das fases do turno e persistência do estado dos aliados em campo.

1.2. Arquitetura Técnica em Flutter/Dart

A arquitetura do aplicativo adota o padrão Clean Architecture para garantir desempenho nativo multiplataforma (Android e iOS), previsibilidade de estado e completo isolamento de responsabilidades técnicas:

* Gerenciamento de Estado: Adoção rigorosa do Riverpod (ou BLoC/Cubit) para encapsular a lógica do motor de regras do TCG em uma camada de domínio pura (Domain/Rules), completamente desacoplada da camada de apresentação visual (Presentation/UI). Essa separação garante que mutações do estado da partida (recursos, fluxo de fases, integridade de bases e contagem de influências) sejam reativas, previsíveis e imunes a inconsistências de renderização.
* Persistência Local Offline-First: Implementação de motores de banco de dados locais de alto desempenho e baixa latência, como Hive, Isar ou Drift (SQLite), operando sob o conceito offline-first. Toda a execução de regras, auditoria de partidas, armazenamento de preferências e histórico local ocorrem diretamente no dispositivo, dispensando infraestrutura de servidor ou conectividade com a internet durante as partidas.
* Modularidade e Extensibilidade Open-Source: Estruturação da base de código em pacotes e módulos independentes (Core, Domain, Presentation, Data). Essa modularização simplifica a governança técnica por contribuidores open-source, permitindo que novas funcionalidades ou atualizações de regras sejam submetidas via Pull Requests sem riscos de regressão no motor central de jogo.

2. Design System e Identidade Visual Inspirada em Fábula TCG

2.1. Paleta de Cores e Identidade Visual

A identidade visual do aplicativo mapeia diretamente as cores oficiais das bases e cartões do universo de Fábula TCG, garantindo consistência semântica e imediato reconhecimento por parte dos jogadores:

Cor Oficial	Aplicação na Interface (UI)	Elemento do Jogo Associado
Branco	Botões primários, marcadores neutros e bordas de seleção ativa	Identidade de cor de Base / Cartas Brancas
Azul	Indicadores de fases do turno, cabeçalhos de estatísticas e seleções da navegação	Identidade de cor de Base / Cartas Azuis
Amarelo	Destaque do contador de recursos e marcadores de prioridade de turno	Identidade de cor de Base / Cartas Amarelas
Verde	Indicadores de vida, marcadores de restauração e estados de saúde de aliados	Identidade de cor de Base / Cartas Verdes
Vermelho	Botões de aplicação de dano, destruição e alertas da subfase de Ofensiva	Identidade de cor de Base / Cartas Vermelhas
Roxo	Marcadores da subfase de Influência, alteração de controle e estados especiais	Identidade de cor de Base / Cartas Roxas
Incolor	Fundos de tela neutros, divisores de interface e cartões desativados	Cartas Incolores e elementos estruturais de UI

2.2. Ergonomia de Interface e Acessibilidade em Mesa

Sintetizando as melhores práticas estabelecidas por aplicativos consolidados no mercado de TCGs (como Lifetap, Lotus, Mythic Tools e Playgroup.gg), a interface atende aos seguintes requisitos de uso presencial:

* Legibilidade à Distância: Tipografia e numeração de recursos e resistência das bases com dimensões ampliadas e alto contraste, permitindo a leitura clara por ambos os jogadores a partir de lados opostos da mesa de jogo.
* Layouts Assecundários e Modos de Mesa: Suporte para múltiplos arranjos de mesa, incluindo exibição espelhada para 2 jogadores (com rotação de 180° no lado do oponente), arranjos assimétricos para posições variadas e suporte para até 6 jogadores em formatos multiplayer. Inspirado no Lifetap, o aplicativo possui modo de auto-ocultamento dos menus operacionais durante a partida e um "Modo Webcam/Stream" com layout limpo e otimizado para transmissão.
* Controle de Tempo e Torneio: Inspirado no Lotus, inclui um cronômetro de rodada integrado configurável para partidas casuais ou torneios presenciais, com alertas sonoros e visuais discretos.
* Registro Rápido e Sem Fricção: Inspirado no Playgroup.gg e Mythic Tools, permite o registro e salvamento imediato do tipo de vitória, duração e avaliação de tom da partida (salt rating) localmente, sem a obrigatoriedade de criação de conta ou login.
* Acessibilidade e Manutenção do Display: Suporte nativo a modos de alto contraste, contraste negativo, escala de cinza, luz de cor de fundo ajustável, fontes adaptadas para dislexia e trava de tela ativa para impedir o bloqueio do dispositivo por inatividade durante a partida.

3. Estrutura do Repositório Open-Source e Governança

3.1. Estrutura de Diretórios do Repositório

A organização do projeto Flutter segue rigorosamente a separação por responsabilidades da Clean Architecture:

fabula_tcg_app/ assets/ icones/ imagens/ lib/ core/ constants/ theme/ utils/ data/ datasources/ models/ repositories/ domain/ entities/ repositories/ rules/ presentation/ components/ screens/ state/ main.dart test/ domain/ presentation/ AGENTS.md pubspec.yaml README.md

3.2. Especificação do Arquivo AGENTS.md

O arquivo AGENTS.md deve residir na raiz do repositório para orientar agentes de IA e desenvolvedores humanos quanto aos padrões de contribuição e regras invioláveis do ecossistema:

* Convenções de Código Dart: Uso estrito das regras de análise estática do Dart SDK (flutter analyze); obrigatoriedade de tipagem forte explícita em métodos e classes; imutabilidade total em modelos de domínio (utilizando @immutable ou Freezed).
* Padrões de Commit: Commits semânticos no padrão Conventional Commits (feat:, fix:, docs:, refactor:, test:, chore:).
* Regras Invioláveis do Motor de Jogo de Fábula TCG:
  1. Regra de Ouro (Regra 1.1.1): O texto explícito do efeito de uma carta prevalece rigorosamente sobre qualquer regra geral do jogo.
  2. Regra de Negação (Regra 1.1.2 / 1.1.2a): Qualquer efeito com construção negativa ("não podem", "não recebem", "nenhum") tem prioridade absoluta e anula efeitos que autorizam ações.
  3. Pilha de Efeitos LIFO (Regra 4.5.3): A resolução de efeitos na pilha ocorre obrigatoriamente na ordem inversa da inserção (do último efeito inserido para o primeiro).
  4. Cálculo Simultâneo de Dano de Ofensiva (Regra 1.22.4a): O dano de combate na subfase de Ofensiva é calculado e aplicado de forma simultânea entre os aliados atacantes e bloqueadores.
  5. Ciclo de Vida de Fichas/Tokens (Regras 1.12.7 e 3.5.2): Fichas que deixam o Campo para qualquer outra zona (Descarte ou Degredo) deixam de existir imediatamente e jamais podem retornar ao jogo.
  6. Valores Inteiros (Regra 1.8.1): Todos os recursos, vida, ofensiva, influência e resistência são valores inteiros não negativos, salvo quando especificado e arredondado pela carta.
* Processo de Revisão: Todo Pull Request deve incluir cobertura de testes unitários para o motor de regras e passar sem avisos na análise estática.

3.3. Especificação do Arquivo README.md (Build e Instalação Manual)

Fábula TCG - Mobile App

Aplicativo open-source em Flutter desenvolvido para atuar como marcador de mesa, assistente de regras e gerenciador de partidas para o jogo de cartas Fábula TCG.

Requisitos do Ambiente

* Flutter SDK (versão estável 3.x ou superior)
* Dart SDK (versão 3.x ou superior)
* Android Studio / Xcode para emulação e compilação nativa

Passos para Compilação e Instalação Manual

1. Clone o repositório oficial: git clone https://github.com/fabula-tcg/fabula-mobile-app.git cd fabula-mobile-app
2. Instale as dependências do projeto: flutter pub get
3. Execute a análise estática e os testes unitários da lógica do jogo: flutter analyze flutter test
4. Execute o aplicativo em ambiente de desenvolvimento: flutter run
5. Gerar pacote de distribuição (Android APK Release): flutter build apk --release

4. Especificação Funcional do MVP: Marcador de Recursos e Estado de Jogo

4.1. Mecanismo e Regras de Recursos

1. Progressão Automática e Incremental (Regra 1.7.2c / 1.18.10): No primeiro turno da partida, o jogador ativo recebe 2 pontos de recursos. A cada novo turno do jogador, seu limite máximo gerado é acrescido em +2 pontos até atingir o limite máximo padrão de 10 pontos de recursos (salvo efeitos de cartas que alterem esse limite).
2. Gerenciamento entre Turnos para Manobras (Regra 1.7.3): Recursos não utilizados durante o turno ativo do jogador permanecem disponíveis durante o turno do oponente para o pagamento de custos de cartas de Manobra ou ativação de habilidades instantâneas.
3. Fase de Restauração e Limpeza (Regra 1.7.2b / 1.18.9): Na Fase de Restauração de cada turno ativo, quaisquer recursos remanescentes do turno anterior são zerados. Em seguida, os pontos de recursos são totalmente restaurados para o valor total alocado para aquele turno específico (respeitando a escala progressiva de 2 a 10 ou modificações ativas).

4.2. Gerenciador de Bases e Pontos de Resistência

A interface deve mapear graficamente a Zona de Território, que é composta obrigatoriamente por 5 bases (4 Arredores e 1 Centro):

Tipo de Base	Qtd Inicial	Resistência Inicial	Formas de Remoção / Conquista	Impacto no Estado do Jogo
Arredores	4	5 pontos	Destruição via dano de Ofensiva (\le 0 de resistência) ou Conquista via disputa de Influência.	Representam os territórios periféricos. Suas perdas progressivas abrem caminho para a exposição do Centro.
Centro	1	15 pontos	Destruição via dano de Ofensiva (\le 0 de resistência) ou Conquista via disputa de Influência.	Representa a capital. A vitória por Captura do Centro ocorre no momento em que o oponente toma ou destrói o Centro.

* Persistência de Dano: O dano causado à resistência das bases permanece entre os turnos.
* Destruição de Base: Quando a resistência de uma base é reduzida a zero ou menos por cálculo de dano na subfase de Ofensiva, ela é destruída e enviada à zona de Descarte.
* Conquista por Influência (Regra 1.22.5a): Na subfase de Influência, o jogador ativo declara os aliados influenciando uma base. O oponente declara os aliados bloqueando a influência. O cálculo compara: \text{Soma da Influência dos Influenciadores} > \text{Soma da Influência dos Bloqueadores} + \text{Resistência Atual da Base} Se a soma dos aliados influenciando for superior, o jogador influenciador assume o controle daquela base.
* Condição de "Centro Exposto" (Regras 3.1.7 a 3.1.11): O Centro do jogador torna-se exposto somente após todos os seus 4 Arredores originais serem destruídos ou influenciados pelo oponente. Enquanto houver ao menos um Arredor original sob controle do jogador, o Centro não pode ser atacado ou influenciado. Regra Estrita: Arredores conquistados do oponente não contam para proteger o próprio Centro e nem impedem que ele permaneça exposto. Caso o jogador recupere o controle de seus Arredores originais, o Centro deixa de estar exposto.

4.3. Auxiliares de Fase de Turno e Ações Pré-Jogo

* Ações Pré-Jogo e Assistente de Mulligan (Regras 1.4.1 a 1.4.5):
  * Sorteador aleatório integrado (moeda/dado digital) para definir a ordem dos turnos e o jogador ativo inicial.
  * Gerenciador de Mulligan: No formato padrão, os jogadores compram a mão inicial de 6 cartas. O app disponibiliza a opção de declarar Mulligan uma única vez antes do início da partida, permitindo enviar qualquer quantidade de cartas ao fundo do baralho em ordem aleatória e comprar a mesma quantidade em seguida.
  * Sinalização do Primeiro Turno: O assistente bloqueia a Fase de Compra do jogador que inicia a partida em seu primeiro turno.
* Rastreador das Fases do Turno (Seção 5):
  1. Fase Inicial / Compra: Compra automática/sinalizada de cartas até atingir 6 cartas na mão (pula no primeiro turno do jogador inicial).
  2. Fase de Restauração: Restauração dos pontos de recurso para o total do turno. Interface para desvirar permanentes/aliados mediante pagamento do custo padrão de 1 recurso por aliado.
  3. Fase de Ação: Janela para posicionar Aliados e Modificações na zona de batalha ou jogar Manobras e ativar habilidades ativadas.
  4. Fase de Combate: Subfase de Ofensiva (declaração de alvos e bloqueadores virados, com cálculo e aplicação simultânea de dano à resistência ou à vida dos aliados) seguida da Subfase de Influência (declaração de influenciadores e bloqueadores virados, com cálculo de margem contra a resistência atual).
  5. Fase Final: Verificação e sinalização para descartar a mão até o limite máximo de 5 cartas (Regra 4.2.5) e restauração total da vida de todos os aliados no campo.
* Marcadores de Estado dos Aliados:
  * Controle do estado Virado/Desvirado.
  * Sinalização visual da condição "Se Preparando" (Regra 3.2.10): Aliados que entram em campo no turno atual ficam impedidos pelo motor do app de realizar ofensiva, influenciar ou ter suas habilidades ativadas naquele mesmo turno.

5. Roadmap de Implantação e Expansões Futuras

5.1. Fase 1: Lançamento do MVP (Marcador Core de Partida)

* Contadores de recursos automatizados com escala incremental (+2 por turno até o teto de 10) e suporte a manobras no turno do oponente.
* Monitor de resistência da Zona de Território mapeando as 5 bases, controle de dano persistente, cálculo de disputa de influência e trava lógica do status de exposição do Centro.
* Rastreador visual interativo do fluxo das 5 fases do turno com assistente de Mulligan e descarte de fim de turno.
* Interface ergonômica com auto-ocultamento, suporte a múltiplos layouts de mesa, cronômetro de rodada e operação 100% offline.

5.2. Fase 2: Módulo de Regras Integrado

* Integração de biblioteca de regras offline contendo a íntegra do Manual e do Livro de Regras Oficial de Fábula TCG.
* Mecanismo de busca e leitor/scanner simples de cartas para consulta offline de Oracle text, custos, cores e categorização por tipos (Aliado, Manobra, Base, Modificação e Fichas).
* Guia interativo sobre a Resolução da Pilha de Efeitos (LIFO), Regra de Ouro, Regra de Negação e zonas de jogo (Baralho, Mão, Campo, Descarte, Pilha e Degredo).

