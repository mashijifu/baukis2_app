FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y build-essential nodejs postgresql-client libpq-dev

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

RUN mkdir /baukis2_app
WORKDIR /baukis2_app
COPY Gemfile /baukis2_app/Gemfile
COPY Gemfile.lock /baukis2_app/Gemfile.lock
RUN bundle install
COPY . /baukis2_app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
