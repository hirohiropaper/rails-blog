# コピペでOK, app_nameもそのままでOK
# 19.01.20現在最新安定版のイメージを取得
FROM ruby:2.6.5

# 必要なパッケージのインストール（基本的に必要になってくるものだと思うので削らないこと）
RUN apt-get update -qq && \
    apt-get install -y build-essential \ 
                       libpq-dev \        
                       nodejs

# 作業ディレクトリの位置
ENV APP_ROOT /work 
ENV APP_USER smith

# 実行ユーザの作成 1000版に固定 (linux用)
RUN  useradd --shell /bin/bash -u 1000 -o -c "" -m $APP_USER --home $APP_ROOT

# 作業ディレクトリ
WORKDIR $APP_ROOT

# ホスト側（ローカル）のGemfileを追加する
COPY --chown=1000 ./Gemfile $APP_ROOT
COPY --chown=1000 ./Gemfile.lock $APP_ROOT

# 以降 smith(1000)で作業
USER $APP_USER
RUN cd $APP_ROOT

# Gemfileのbundle install
RUN bundle install
ADD --chown=1000 . $APP_ROOT
