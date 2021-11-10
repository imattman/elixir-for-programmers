FROM elixir:latest

RUN apt-get update && \
      apt-get install -y inotify-tools && \
      mix local.hex --force


ENV APP_HOME /app/hangman
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

CMD ["iex", "-S", "mix"]

