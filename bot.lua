local discordia = require("discordia")
local json = require("json")
local http = require("coro-http")
local client = discordia.Client()
local unpack = table.unpack or unpack
local token = client.env.token--your own bot's token here


--[[
    Notes
]]


function Joke(message)
    coroutine.wrap(function()
        local link = "https://icanhazdadjoke.com/slack"
        local result, body = http.request("GET", link)

        body = json.parse(body)  


        -- $ curl -H "Accept: application/json" https://icanhazdadjoke.com/
        -- print(body["joke"])
        message:reply("<@!"..message.member.id.."> "..body["attachments"][1].fallback)
    end)()
end

function cute(message)
    coroutine.wrap(function()
        local link = "https://www.reddit.com/r/eyebleach/new.json"
        local result, body = http.request("GET", link)

        body = json.parse(body)  

        message:reply(body["data"]["children"][math.random(1, 23)]["data"].url)
    end)()
end


client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
end)

-- message create

client:on("messageCreate", function(message)
    
    if message.author.bot then return end -- Make sure a bot cannot execute this command.

    local content = message.content
    local member = message.member
    local memberid = message.member.id

    if content:lower() == "tell me a joke" then
        message:reply("kunal")
    end
    if content:find("ping") then
        message:reply("pong")
    end
    if content:lower() == "~joke" then
        Joke(message)
    end
    if content:lower() == "~cute" then
        cute(message)
    end

end)

-- client:run("Bot "..io.open("./login.txt"):read())
client:run("Bot "..token)