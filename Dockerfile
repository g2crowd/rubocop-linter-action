FROM ruby:2.6.6-alpine

RUN apk --no-cache add build-base git

COPY lib /action/lib
COPY README.md LICENSE entrypoint.sh /

RUN gem install bundler:1.17.3 --no-document

ENTRYPOINT ["/entrypoint.sh"]
