module.exports = (robot) ->

   robot.hear /rambot, where are you?/i, (res) ->
     os = require('os');
     ifaces = os.networkInterfaces();
     Object.keys(ifaces).forEach (ifname) ->
       ifaces[ifname].forEach (iface) ->
         if 'IPv4' != iface.family or iface.internal != false
           # skip over internal (i.e. 127.0.0.1) and non-ipv4 addresses
           return
       # this interface has only one ipv4 adress
         res.send 'here somewhere: ' + ifname, iface.address
         return
       return
