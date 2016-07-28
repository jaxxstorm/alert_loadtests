# alert_loadtests

A bunch of ruby scripts to generate a load of alerts

# Why

We're evaluating replacements to pagerduty, and one of the issues is how the web UI handles a lot of alerts. This allows you to generate a bunch of them in a short period

# How

Use a modern ruby ( > 1.9.3 )

Install trollop with bundler

```
bundle install
```

run the commands with bundler:

```
bundle exec ruby opsgenie.rb -c <customerkey> -n 100
```


