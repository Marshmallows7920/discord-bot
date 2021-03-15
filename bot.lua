local discordia = require("discordia")
local json = require("json")
local http = require("coro-http")
local client = discordia.Client()
local unpack = table.unpack or unpack
local token = os.getenv("token")--your own bot's token here

local affirmations = {
    "Don’t sweat the small stuff.",
    "You are love. You are purpose. You were made with divine intention.",
    "You can. You will. End of story.",
    "You are adventurous. You overcome fears by following your dreams.",
    "You feed your spirit. You train your body. You focus your mind. It’s your time.",
    "You are in charge of how you feel and today you are choosing happiness.",
    "You are your own superhero.",
    "You will not compare myself to strangers on the Internet.",
    "You are choosing and not waiting to be chosen.",
    "You are enough.",
    "You are whole.",
    "You have the power to create change.",
    "You let go of all things that no longer serve you.",
    "You can do all things.",
    "You refuse to give up because you haven’t tried all possible ways.",
    "You deserve the best and you will accept the best now.",
    "You're going to make everyone so proud.",
    "Your presence is your power.",
    "When you really want it, you are unstoppable."}

local jokes = {
    "kunal","mohsen","Yashas","Andrea","Ronnie","Marc Yu"
}

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
        local link = "https://www.reddit.com/r/eyebleach/new.json?limit=100"
        local result, body = http.request("GET", link)

        body = json.parse(body)  

        message:reply(body["data"]["children"][math.random(1, 100)]["data"].url)
    end)()
end

function meme(message)
    coroutine.wrap(function()
        local link = "https://www.reddit.com/r/wholesomememes/new.json?limit=100"
        local result, body = http.request("GET", link)

        body = json.parse(body)  

        message:reply(body["data"]["children"][math.random(1, 100)]["data"].url)
    end)()
end

function food(message)
    coroutine.wrap(function()
        local link = "https://www.reddit.com/r/food/new.json?limit=100"
        local result, body = http.request("GET", link)
        local postnum = math.random(1, 100)

        body = json.parse(body)  

        message:reply(
            body["data"]["children"][postnum]["data"].title.."\n"..
            body["data"]["children"][postnum]["data"].url)
    end)()
end

function info(message)
    coroutine.wrap(function()
        local ts=tostring
        local cpu=uv.cpu_info()
        local threads=#cpu
        local cpumodel=cpu[1].model
        local mem=math.floor(collectgarbage('count')/1000)

        message:reply {
			embed = {
				title = "Info",
				fields = {
					{name = "OS: ", value = ts(operatingsystem),inline = false},
					{name = "CPU Threads: ", value = ts(threads),inline = false},
					{name = "CPUT Mode: ", value = ts(cpumodel), inline = false},
                    {name = "Memory Usage: ", value = ts(mem).." MB", inline = false}
				}
			}
		}

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



    -- Ping
    if content:find("ping") then
        message:reply("🏓pong")
        -- local otime = os.time - message.createdAt
        -- local ctime = client:ping
        -- message:reply("🏓Latency is "..otime.."ms. API Latency is " ..ctime.."ms")
    end

    -- Joke
    if content:lower() == "~joke" then
        Joke(message)
    end

    -- Cute
    if content:lower() == "~cute" then
        cute(message)
    end

    -- Meme
    if content:lower() == "~meme" then
        meme(message)
    end

    -- Food
    if content:lower() == "~food" then
        food(message)
    end

    -- Sad
    if content:lower() == "~sad" then
        message:reply("don't be sad!")
        message:reply(affirmations[ math.random( #affirmations ) ])
        cute(message)
    end

    -- Coin
    if content:lower() == "~coin" then
        local coin1 = math.random(1,100)
        if coin1 > 50 then
            message:reply("Heads (\\*^▽^\\*)")
        elseif coin1 == 50 then
            message:reply("THE COIN LANDED ON ITS EDGE (╯°□°）╯︵ ┻━┻")
        else
            message:reply("Tails (✿◡‿◡)")
        end
    end

    -- Info
    if content:lower() == "~info" then
        info(message)
    end

    -- Help Menu
    if content:lower() == "~help" then
        if message.guild.id ~= "724363919035990106" then
            message:reply {
                embed = {
                    title = "Invite to your Server",
                    url = "https://discord.com/api/oauth2/authorize?client_id=786804598835904543&permissions=388161&scope=bot",
                    description = "Command List",
                    author = {
                        name = "Help Menu",
                        icon_url = "https://i.imgur.com/dqsdblw.png"
                    },
                    thumbnail = {url = "https://i.pinimg.com/originals/4b/94/94/4b949483527c5d6793318346ec327b2f.jpg"},
                    fields = {
                        {name = "~joke", value = "jokes",inline = false},
                        {name = "~cute", value = "cute pictures",inline = false},
                        {name = "~meme", value = "wholesome memes", inline = false},
                        {name = "~food", value = "yumyum", inline = false},
                        {name = "~sad", value = "sad no more", inline = false},
                        {name = "~coin", value = "flip a coin", inline = false},
                        {name = "-----", value = "Other messages will be sent based on message context", inline = false}
                    },
                    color = discordia.Color(85, 211, 197).value,
                    -- timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
                    footer = {text = message.author.name.." | Made by Marshmallows7920 - version 1.0.1 2021"}
                }
            }
        else
            message:reply {
                embed = {
                    title = "Invite to your Server",
                    url = "https://discord.com/api/oauth2/authorize?client_id=786804598835904543&permissions=388161&scope=bot",
                    description = "Command List",
                    author = {
                        name = "Help Menu",
                        icon_url = "https://i.imgur.com/dqsdblw.png"
                    },
                    thumbnail = {url = "https://i.pinimg.com/originals/4b/94/94/4b949483527c5d6793318346ec327b2f.jpg"},
                    fields = {
                        {name = "~joke", value = "jokes",inline = false},
                        {name = "~cute", value = "cute pictures",inline = false},
                        {name = "~meme", value = "wholesome memes", inline = false},
                        {name = "~food", value = "yumyum", inline = false},
                        {name = "~sad", value = "sad no more", inline = false},
                        {name = "~coin", value = "flip a coin", inline = false},
                        {name = "-----", value = "Automated messages disabled on this server", inline = false}
                    },
                    color = discordia.Color(85, 211, 197).value,
                    -- timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
                    footer = {text = message.author.name.." | Made by Marshmallows7920 - version 1.0.1 2021"}
                }
            }
        end
	end
    
    -- disabled on cs server
    if message.guild.id ~= "724363919035990106" then
        
        -- Sad
        if content:find("I'm sad") then
            message:reply("don't be sad!")
            message:reply(affirmations[ math.random( #affirmations ) ])
            cute(message)
        end

        -- Bad
        if content:find("bad") then
            message:reply("not bad")
        end

        -- Love
        if content:find("I love") then
            message:reply("I love you")
        end

        -- Wholesome
        if content:find("wholesome") then
            message:reply("Quite Wholesome")
        end

        -- Kunal
        if content:lower() == "tell me a joke" then
            message:reply(jokes[math.random(#jokes)])
        end
    end

end)

-- client:run("Bot "..io.open("./login.txt"):read())
client:run("Bot "..token)