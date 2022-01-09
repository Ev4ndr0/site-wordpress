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
```

```sh
git clone https://github.com/dev-acnsf/docker-wordpress.git
```

```sh
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