# PWCBeyond

Tool to create and keep track of characters in homebrew tabletop RPG (pen&paper) Planewalker Chronicles 

## Features

* Create your character: Create either a plain human or a planewalker character. You will have to fill its physical and personality traits, his past and his life goals. Decide what atributes and skills the character has. Finally, if you are creating a planewalker pick a Via and choose which supernatural abilities fit best.

* Use your character: Choose a previously created character and watch all its information; also keep track of how tired and how hurt (both physically and mentally) it is. 
There are two layouts available: a Dashboard layout thought for a 1080p screen and a Webview layout which will fit best for any other screen resolution.
There is a rolling dice tool, just click which atribute and skill you are going to use and press the die icon; if a discord webhook is set, the result will be send to your discord room.

* Master mode: Choose up to 6 existing characters to keep track of their vitals and to have quick access to their full information. In this section there will be a reference for some rules and a part for notes.

## Getting Started

### Setting up backend

For the app to work it is needed to setup the backend first, 
the backend consists in postgresql database and a postgREST wrapper to convert the access to the db into a RESTful API. 

In the [backend](https://github.com/ricargoes/pwcbeyond/tree/main/backend) dir there are instructions on how to set it up.

### Connecting App to backend

Once the database and the RESTful API are set, Godot needs to know where to find them. 
That can be done setting the host var in the [GameInfo](https://github.com/ricargoes/pwcbeyond/blob/b2d6c7c2d719719cba79b1c966afa4199d609345/scenes/singletons/GameInfo.gd#L70) singleton to the address of the server and the port of the RESTful API.

For example, using the postREST default settings and setting the server in the same computer as the godot app, the variable will be set as: `var host = 'http://127.0.0.1:3000'`.

### Connecting to Discord webhook

The app has a feature to make dice rolls, these rolls can be send to a discord room if a [webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) has been set in that room.

Just find the var discord_webhook_url in the [GameInfo]([GameInfo](https://github.com/ricargoes/pwcbeyond/blob/b2d6c7c2d719719cba79b1c966afa4199d609345/scenes/singletons/GameInfo.gd#L70) to the address of the server and the port of the RESTful API.
) singleton and set it to your webhook address.
