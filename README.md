# Ruby on Rails Code Interview

Sistema desenvolvido para avaliação técnica com Ruby on Rails. O projeto abrange correções de filtros, paginação com cursor, CRUD, envio de e-mails, relatórios com background jobs e testes automatizados.

## Regras
1. **fazer fork do projeto para seu github**
2. **atualizar a versão do ruby e do rails**
3. **criar o dockerfile e o docker-compose**
4. **enviar o link do seu repositório para avaliação**
5. **não usar IA, e nem copiar de outros projetos, nesse caso será desclassificado**

---

## ⚙️ Funcionalidades

1. **Correção de filtros**
   - Filtro por empresa corrigido para retornar apenas usuários da empresa especificada.
   - Filtro por nome de usuário ajustado para permitir buscas parciais e case-insensitive com `ILIKE`.

2. **Teste geral**
   - RSpec com cobertura de casos de uso para todas as funcionalidades do sistema.

3. **Tweets com paginação por cursor**
   - `GET /tweets`: lista tweets ordenados por mais recentes com paginação baseada em cursor.
   - `GET /users/:user_id/tweets`: mesma lógica aplicada para tweets de um usuário.
   - Criar a relação entre usuário e tweet.

4. **CRUD de Empresas**
   - CRUD completo com páginas HTML (`CompaniesController`).

5. **Mailer de novo usuário**
   - E-mail enviado automaticamente ao cadastrar novo usuário.

6. **Relatório em segundo plano**
   - Relatório gerado com um service/repository usando Sidekiq (`ReportGenerationJob`).
   - O primeiro relatório deve listar todos os usuários e seus tweets, ordenados por data de criação.
   - O segundo relatório deve mostrar as empresas e o número de usuários associados a cada uma.

7. **Cobertura de testes**
   - Cobertura extraída com SimpleCov. Relatório em `coverage/index.html`.

8. **Gerar um relatório com QUERY RAW usando joins, e otimizando a query com indices**
   - aqui você pode criar as tabelas e indices que você achar melhor para demostrar suas habilidades.

9. **utilização de hotwire ou stimulus**
   - aqui é para você mostrar seu conhecimento de ambos.

---

## ▶️ Como rodar

1. Clone o repositório: 

```bash
git clone git@github.com:msviniciius/coding-interview.git
cd coding-interview.

2. Crie um arquivo .env com as variáveis de ambiente necessárias:

POSTGRES_USER=seu_usuario
POSTGRES_PASSWORD=sua_senha
POSTGRES_DB=nome_do_banco
DATABASE_URL=postgres://seu_usuario:sua_senha@db:5432/nome_do_banco
REDIS_URL=redis://redis:6379/0

3. Build e start dos containers:

docker-compose up --build

---

## 🟡 Isso vai

Preparar o banco (rails db:prepare)
Subir o servidor Rails na porta 3000 (http://localhost:3000)
Subir Sidekiq para processamento de jobs
Subir Redis e MailCatcher
Acessar a aplicação:
Aplicação Rails: http://localhost:3000
MailCatcher: http://localhost:1080


## ✅ Como testar

4. Dentro do container Docker, rode:

docker-compose run --rm web bundle exec rspec

5. Para rodar com documentação detalhada:

docker-compose run --rm web bundle exec rspec --format documentation