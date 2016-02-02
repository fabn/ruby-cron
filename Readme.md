# Ruby Cron

Simplest cron replacement using ruby and [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) gem.

In order to run this scheduler you should define your tasks in a `jobs.rb` file and start the image.

## Jobs file example 


```ruby
# in jobs.rb
scheduler = Rufus::Scheduler.singleton

scheduler.every '5s' do
  me = `whoami`.chomp
  $logger.info "Running under user #{me}"
end
```

Run with `docker run -it --rm fabn/ruby-cron`, expected output:

```
I, [2016-02-02T11:36:28.049711 #7]  INFO -- : Rufus scheduler started
I, [2016-02-02T11:36:33.191058 #7]  INFO -- : Running under user root
I, [2016-02-02T11:36:38.317653 #7]  INFO -- : Running under user root
I, [2016-02-02T11:36:43.137946 #7]  INFO -- : Running under user root
^CI, [2016-02-02T11:37:18.724403 #7]  INFO -- : All jobs have been terminated, exiting
```

Terminate it with Ctrl+C or with SIGTERM. Scheduler will wait for running jobs.