FROM ruby:3.2-slim

WORKDIR /srv/jekyll

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 4000 35729

CMD ["bundle", "exec", "jekyll", "serve", "--livereload", "--force_polling", "--host", "0.0.0.0", "--port", "4000"]
