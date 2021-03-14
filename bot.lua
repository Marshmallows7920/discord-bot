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

        message:reply(body["data"]["children"][math.random(1, 98)]["data"].url)
    end)()
end

function meme(message)
    coroutine.wrap(function()
        local link = "https://www.reddit.com/r/wholesomememes/new.json?limit=100"
        local result, body = http.request("GET", link)

        body = json.parse(body)  

        message:reply(body["data"]["children"][math.random(1, 98)]["data"].url)
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
    if content:find("sad") then
        message:reply("don't be sad!")
        message:reply(affirmations[ math.random( #affirmations ) ])
        cute(message)
    end
    if content:find("bad") then
        message:reply("not bad")
    end
    if content:lower() == "~meme" then
        meme(message)
    end
    if content:find("love") then
        message:reply("I love you")
    end
    if content:find("wholesome") then
        message:reply("Quite Wholesome")
    end
    if content:lower() == "~help" then
		message.channel:sendMessage {
			embed = {
				title = "Invite to your Server",
                url = "https://discord.com/api/oauth2/authorize?client_id=786804598835904543&permissions=388161&scope=bot"
				description = "Command List",
                author = {
					name = "Help Menu",
					icon_url = "https://i.imgur.com/dqsdblw.png"
				},
                thumbnail = {
                    url = "https://i.pinimg.com/originals/4b/94/94/4b949483527c5d6793318346ec327b2f.jpg"
                },
				fields = {
					{name = "~joke", value = "jokes",inline = false},
					{name = "~cute", value = "cute pictures",inline = false},
					{name = "~meme", value = "wholecome memes", inline = false},
                    {name = "", value = "Other messages will be sent based on message context", inline = false},
				},
				color = discordia.Color(128, 255, 255).value,
				timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
				footer = {text = message.author.name.." | Made by Marshmallows7920 - version 1.0.1 2021"}
			}
		}
	end	
end)

-- client:run("Bot "..io.open("./login.txt"):read())
client:run("Bot "..token)