# Issue

https://github.com/rails/rails/issues/25381

# TL;DR

It looks like broadcasting in subscribe block causes the issue. Moving this code to the background i. e. Celluloid::Future "solves" the issue.

# How to reproduce it?

On first terminal:

```
$ docker-compose up
```

On second terminal:

```
$ docker-compose exec app rails c
```

and paste:

``` ruby
w = WebSocket::Client::Simple.connect("ws://app:3000/ws") do |ws|
  ws.on :open do
    ws.send '{"command": "subscribe","identifier":"{\"channel\":\"ApiChannel\"}"}'
  end

  ws.on :message do |m|
    if m.data == '{"identifier":"{\"channel\":\"ApiChannel\"}","type":"confirm_subscription"}'
      ws.send '{"command": "message","data": "{}", "identifier":"{\"channel\":\"ApiChannel\"}"}'
    end
  end
end
sleep 2
w.close
```

and watch the logs:

```
app_1    | Started GET "/ws" for 172.19.0.3 at 2016-09-16 08:34:47 +0000
app_1    | Started GET "/ws/" [WebSocket] for 172.19.0.3 at 2016-09-16 08:34:47 +0000
app_1    | Successfully upgraded to WebSocket (REQUEST_METHOD: GET, HTTP_CONNECTION: Upgrade, HTTP_UPGRADE: websocket)
app_1    | [ActionCable] Broadcasting to api:ceb09678-074e-44d6-9860-64a063193bae: {:subscribe=>true}
app_1    | [ActionCable] Broadcasting to api:19556d33-d186-48f6-943a-94bfd9cfb3c2: {:subscribe=>true}
app_1    | ApiChannel is transmitting the subscription confirmation
app_1    | [ActionCable] Broadcasting to api:5091ecb2-a69c-4130-a1d9-eb66863c3034: {:subscribe=>true}
app_1    | ApiChannel is streaming from api:7ebe73bc-dc88-408c-8df8-020f75bfc24e
app_1    | [ActionCable] Broadcasting to api:50a83eeb-3c4f-4738-9a39-c2bee872c705: {:subscribe=>true}
app_1    | Could not execute command from {"command"=>"message", "data"=>"{}", "identifier"=>"{\"channel\":\"ApiChannel\"}"}) [RuntimeError - Unable to find subscription with identifier: {"channel":"ApiChannel"}]: /usr/local/bundle/gems/actioncable-5.0.0.1/lib/action_cable/connection/subscriptions.rb:70:in `find' | /usr/local/bundle/gems/actioncable-5.0.0.1/lib/action_cable/connection/subscriptions.rb:49:in `perform_action' | /usr/local/bundle/gems/actioncable-5.0.0.1/lib/action_cable/connection/subscriptions.rb:17:in `execute_command' | /usr/local/bundle/gems/actioncable-5.0.0.1/lib/action_cable/connection/base.rb:88:in `dispatch_websocket_message' | /usr/local/bundle/gems/actioncable-5.0.0.1/lib/action_cable/server/worker.rb:58:in `block in invoke'
```
