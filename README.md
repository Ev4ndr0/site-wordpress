# AMBIENTE WORDPRESS

_Aqui você vai encontrar um ambiente docker local para conseguir subir uma instância de um site wordpress do zero. Bastando executar somente\* um simples comando Make_

## Pré-requisitos

Considerando que o seu ambiente é Windows, você vai precisar ter um ambiente mínimo para conseguir ter o melhor proveito desta arquitetura. Os seguintes softwares são obrigatórios para subir o ambiente:

-   `WSL2`: No quesito de escolha da distribuição linux para o ambiente WSL2, a recomendação é por instalar o Ubuntu. [tutorial de instalação](https://docs.microsoft.com/pt-br/windows/wsl/install)
-   `Docker:` [tutorial de instalação](https://docs.docker.com/desktop/windows/install/)
-   `VSCode`: Esta é nossa IDE padrão de desenvolvimento [link download](https://code.visualstudio.com/download)
-   `Git`: Sistema padrão de controle de versão de códigos [tutorial de instalação](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
-   `Firefox`: Como temos alguns legados da época em que haviam muitos conflitos entre os diversos browsers existentes, convencionamos o uso do Firefox como principal browser [link download](https://www.mozilla.org/en-US/firefox/new/)

## Instruções

Uma vez que todo o ambiente estiver completo, faça o clone deste projeto para seu ambiente WSL2

```sh
cd ~
git clone https://github.com/dev-acnsf/docker-wordpress.git

cd docker-wordpress
```

##### _Subir container:_

Uma vez que estiver dentro da pasta do projeto, você encontrará o arquivo `.env.example` que conterá todas as configurações necessárias para subir o docker do Wordpress e do MySQL. Execute o seguinte comando:

```sh
make up
```

-   Uma vez que o ambiente subir, no console do prompt, vai ser exibido o link para acesso via intranet: `http://localhost:8088`
-   Ao acessar via browser, serão solicitados dados para criação do motor Wordpress (Título para o site, usuário, senha e e-mail)

##### _Baixar container:_

Para interromper o container, basta executar o comando:

```sh
make down
```

## Desafio

O desafio é muito simples do ponto de vista técnico. Todos os passos anteriores para montagem do ambiente, bem como os passos seguintes, vão ser avaliados. Com o ambiente montado, o desafio principal será:

| Pasos                                  | Detalhes                                                                                                                                                                                                                                                                                                                                                                                      |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Efetuar configurações Padrão           | Configurar Wordpress com títulos, URL's amigáveis e demais detalhes. Obs.: Utilizar plugins como Yoast ou All in One para SEO será um diferencial                                                                                                                                                                                                                                             |
| Criar Plugin Shortcode Para formulário | Criar um plugin que utiliza recursos de Shortcode para renderização de um formulário no corpo de um post. Campos: nome, e-mail e cpf com validação simples em Javascript (bordas avermelhadas e mensagem estilizada). Premissa: Esse formulário tem que ter os arquivos form.html, form-validate.js e form.css incorporados em arquivos separadamente.                                        |
| Criar Homepage Utilizando Elementor    | Criar uma Homepage seguindo como referência, outros sites que carregam os elementos como: menu suspenso, banner carousel e sections no body da página. Fontes para inspiração: https://salvaimerainha.org.br/ e https://www.fatima.org.br/ . O tema da homepage deve ser 13 de maio. O que será avaliado neste quesito são as competências de composição de elementos e organização do layout |
| Criar Página para Formulário           | Este página, será para renderizar o formulário criado através do plugin Shortcode. Ao submeter o formulário livre de erros, exibir uma segunda página de sucesso, com uma mensagem contendo os dados que formam submetidos em sessão($\_SESSION). Utilizar banco de dados para captura do formulário será mais um diferencial                                                                 |

## Entrega do projeto

Para conclusão do desafio, crie um projeto no seu Github pessoal e submeta seu projeto com um README.md adequado, explicando a lógica ou conceito aplicado em cada passo implementado, para analisarmos como você organiza suas ideias frente a prática do desafio.

Este desafio pode ser entregue em 4 dias. Ao término, por favor nos encaminhar o link do projeto no github para podermos avaliar sua entrega. Boa sorte!
