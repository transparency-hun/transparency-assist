# Overcommit

* setup the hooks with `overcommit --install`
* if you change `.overcommit.yml` you need to sign it with `overcommit --sign`

# ENV variables

* `WATIR_BROWSER` Use `phantomjs` locally, `remote` in staging/production.
* `EC2_REGION`
* `EC2_ACCESS_KEY_ID`
* `EC2_SECRET_ACCESS_KEY`
* `EC2_INSTANCE_ID`
* `EC2_INSTANCE_USER`
* `EC2_INSTANCE_HOST`
* `RECAPTCHA_SITE_KEY`
* `RECAPTCHA_SECRET_KEY`

# Tests

To run tests locally use `bundle exec rake ci:build`.

# Crawlers

* `bundle exec rake crawl:kozbeszerzes[year,category]`
* `bundle exec rake crawl:ksh_kao110`
* `bundle exec rake crawl:ksh_kao120`
* `bundle exec rake crawl:mvh_gov_hu[year]`
* `bundle exec rake crawl:nka[year]`
* `bundle exec rake crawl:all`
* `bundle exec rake crawl:all_recent`
* `bundle exec rake crawl:all_historical`

To switch logger to stdout use `bundle exec rake to_stdout crawl:all`

To debug with a smaller set of items use `bundle exec rake to_stdout crawl:all DEBUG=true`

Don't put space between arguments: `bin/rake to_stdout crawl:kozbeszerzes\[2015,railway\]` You may have to escape brackets if zsh is used: `bundle exec rake crawl:mvh_gov_hu\[2014\]`


