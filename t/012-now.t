# vim:set ft= ts=4 sw=4 et fdm=marker:
use lib 'lib';
use Test::Nginx::Socket;

#worker_connections(1014);
#master_process_enabled(1);
log_level('warn');

repeat_each(1);

plan tests => repeat_each() * (blocks() * 2);

#no_diff();
#no_long_string();
run_tests();

__DATA__

=== TEST 1: use ngx.now in content_by_lua
--- config
    location = /now {
        content_by_lua 'ngx.say(ngx.strtime())';
    }
--- request
GET /now
--- response_body_like: ^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$



=== TEST 2: use ngx.now in set_by_lua
--- config
    location = /now {
        set_by_lua $a 'return ngx.strtime()';
        echo $a;
    }
--- request
GET /now
--- response_body_like: ^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$



=== TEST 3: use ngx.utc_time in content_by_lua
--- config
    location = /utc_time {
        content_by_lua 'ngx.say(ngx.utc_time())';
    }
--- request
GET /utc_time
--- response_body_like: ^\d{10}$



=== TEST 4: use ngx.utc_time in set_by_lua
--- config
    location = /utc_time {
        set_by_lua $a 'return ngx.utc_time()';
        echo $a;
    }
--- request
GET /utc_time
--- response_body_like: ^\d{10}$

