print('init.lua')

print('connecting to nande2')
wifi.setmode(wifi.STATION)
wifi.sta.config("nande2","")
tmr.alarm(0,1000, 1, function()
  if wifi.sta.getip() == nil then
    print("Connecting...")
  else
    tmr.stop(0)
    print("Connected, IP is "..wifi.sta.getip())
  end
end)

print('connecting to IFTTT trigger')
Tstart  = tmr.now()
conn = nil
conn=net.createConnection(net.TCP, 0) 

-- show the retrieved web page

conn:on("receive", function(conn, payload) 
                       success = true
                       print(payload) 
                       end) 

-- when connected, request page (send parameters to a script)
conn:on("connection", function(conn, payload) 
                       print('\nConnected') 
                       conn:send("GET /trigger/test/with/key/Px7yCFFlpnbaICHK6f_Q0?"
                        .."T="..(tmr.now()-Tstart)
                        .."&heap="..node.heap()
                        .." HTTP/1.1\r\n" 
                        .."Host: maker.ifttt.com\r\n" 
                          .."Connection: close\r\n"
                        .."Accept: */*\r\n" 
                        .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" 
                        .."\r\n")
                       end) 
-- when disconnected, let it be known
conn:on("disconnection", function(conn, payload) print('\nDisconnected') end)
                                             
conn:connect(80,'maker.ifttt.com') 