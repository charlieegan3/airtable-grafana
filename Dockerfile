FROM ruby:2.4.1

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY app.rb .

ENTRYPOINT ["ruby"]
CMD ["/app/app.rb", "-p", "8080"]
