FROM ruby:3.4.5

WORKDIR /app

# Dependências do sistema + Node + Yarn
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      curl \
      git \
      pkg-config \
      libmsgpack-dev \
      libsqlite3-dev \
      libffi-dev \
      zlib1g-dev \
      libssl-dev \
      ca-certificates \
      gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Copiar Gemfile primeiro (cache)
COPY Gemfile Gemfile.lock ./

# Instalar bundler e gems
RUN gem install bundler && bundle install --jobs 4 --retry 3

# Copiar restante da aplicação
COPY . .

# Garantir que o diretório bin/ exista
RUN if [ -d bin ] && [ "$(ls -A bin)" ]; then chmod +x bin/*; fi

# Pré-compilar assets
RUN bin/rails assets:precompile || true

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
