# Teste iOS

Esse é um projeto feito para um teste técnico, escolhi o nome SiMovie como forma de descontração com a empresa que está fazendo a seleção. Toda a especificação essencial foi feita e mais alguns pontos extras foram adicionados.

  - Animações
  - Testes unitários
  - Utilização de framework de terceiros
    [Realm](https://github.com/realm/realm-cocoa) e
    [SkeletonView](https://github.com/Juanpe/SkeletonView) 
  - Telas adequadas para vários tamanhos de iPhones
  - Utilização de banco de dados local (Realm)
  - Pequenas melhorias de layout/especificações para deixar o app mais atraente.
  - `Localizable`
  - `Swift Package Manager`
  
# Arquitetura

Optei por criar uma arquitetura MVVM, utilizando Storyboards (dado que o tamanho do projeto é pequeno), padrões de "MARK:'s" nas classes para organizar o projeto, além de centralizar as Strings em um arquivo Localizable, tornando possível a internacionalização ou apenas facilitando a manutenção da mensageria do app.

Escolhi o Swift Package Manager pela facilidade de utilização do projeto (e por ser algo novo e muito interessante que a Apple lançou). Basta realizar o `git clone`, abrir o projeto (aguardar fazer o download das bibliotecas) e já estará pronto para uso.

