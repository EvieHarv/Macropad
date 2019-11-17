browser.commands.onCommand.addListener(function(command) {
    handleAsync(command)
});

async function handleAsync(command)
{
    requestEvent(command, await getScope());
}

// Returns {id: int, type: ["youtube"||"music"||"invalid"]}
async function getScope()
{
    // Current youtube page, or youtube music if none are active. Returns an object {id: int, type: "youtube"||"music"}
    let fId = null;
    let fType = "none";

    let found = false;

    await browser.tabs.query({audible: true}).then(function(tabs)
    {
        if (tabs.length === 1)
        {
            if (tabs[0].url.includes("music.youtube.com"))
            {
                fId = tabs[0].id;
                fType = "music";
            }
            else if (tabs[0].url.includes("youtube.com"))
            {
                fId = tabs[0].id;
                fType = "youtube";
            }
        } // Else - More than 1 audible, or not youtube.
    }, onError)

    if (fId === null || fType === "none")
    {
        let curr = await browser.windows.getCurrent({populate: true});
        await browser.tabs.query({active: true}).then(function(tabs) // Check for current tab being youtube.
        {
            for (i in tabs)
            {
                if (curr.tabs.filter(x => x.id === tabs[i].id).length === 1) // Current Tab in Last Activated Window
                {
                    if (tabs[i].url.includes("music.youtube.com"))
                    {
                        fId = tabs[i].id
                        fType = "music";
                    }
                    else if (tabs[i].url.includes("youtube.com"))
                    {
                        fId = tabs[i].id
                        fType = "youtube";
                    }
                }
            }
            if (fId === null || fType === "none") // Current tab not YT, lets try yoinking one from 'actives'?
            {
                let filtered = tabs.filter(x => x.url.includes("youtube.com") );
                if (filtered.length === 1)
                {
                    filtered = filtered[0]
                    fId = filtered.id;
                    if (filtered.url.includes("music.youtube.com"))
                    {
                        fType = "music";
                    }
                    else
                    {
                        fType = "youtube";
                    }
                }
            }    
        }, onError);
    }
    // No clear active tab (No sound, on 2+ Youtube Pages, or none)
    // Time to check for an active music.youtube page. If multiple exist, choose the one with the lowest ID.

    if (fId === null || fType === "none")
    {
        await browser.tabs.query({url: "*://music.youtube.com/*"}).then(function(tabs)
        {
            tabs.sort((a, b) => {(a.id > b.id) ? 1 : -1}); // Sorts list by ID
            fId = tabs[0].id;
            fType = "music";
        })
    }

    if (fId === null || fType === "none")
    {
        return {id: null, type: "invalid"};
    }

    return {id: fId, type: fType};
}

async function requestEvent(command, scope)
{
    if (scope.type==="youtube") // G O O D
    {
        switch(command)
        {
            case "playPause": // fine
                browser.tabs.executeScript(scope.id, {code: "if (document.getElementsByTagName('video')[0].paused) document.getElementsByTagName('video')[0].play(); else document.getElementsByTagName('video')[0].pause();"});
                //browser.tabs.executeScript(scope.id, {code: "if (document.getElementsByTagName('video')[0].paused) document.getElementsByTagName('video')[0].play(); else document.getElementsByTagName('video')[0].pause();"});
                break;
            case "volumeUp": // fixed
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].volume += .05"});
                break;
            case "volumeDown": // fixed
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].volume -= .05"});
                break;
            case "listFW": // look
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"ytp-next-button ytp-button\")[0].click()"});
                break;
            case "listBW": // look
                browser.tabs.executeScript(scope.id, {code: "if (document.getElementsByClassName(\"ytp-prev-button ytp-button\")[0].style.toSource() != \"({0:\\\"display\\\"})\") {document.getElementsByClassName(\"ytp-prev-button ytp-button\")[0].click();} else {document.getElementsByTagName('video')[0].fastSeek(0);}"});
                break;
            case "timeFW": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].currentTime += 5"});
                break;
            case "timeBW": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].currentTime -= 5"});
                break;
            case "multiUp": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].playbackRate+=.25"});
                break;
            case "multiDown": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].playbackRate-=.25"});
                break;
            case "multiL": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].playbackRate=1"});
                break;
            case "multiR": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].playbackRate=2"});
                break;                    
            default:
                console.log("Invalid command in RequestEvent handler.")
                break;
        }
        return;
    }
    else if (scope.type==="music") // volume machine broke
    {
        switch(command)
        {
            case "playPause": // fine
                browser.tabs.executeScript(scope.id, {code: "if(document.getElementsByTagName(\"video\")[0].paused)document.getElementsByTagName(\"video\")[0].play(); else document.getElementsByTagName(\"video\")[0].pause()"});
                //browser.tabs.executeScript(scope.id, {code: "if(player.playerApi_.getPlayerState() === 2) {player.playerApi_.playVideo()} else {player.playerApi_.pauseVideo()}"});
                break;
            case "volumeUp": // Obsolete
                //browser.tabs.executeScript(scope.id, {code: "document.getElementById('volume-slider').value += 5"});
                break;
            case "volumeDown": // Obsolete
                //browser.tabs.executeScript(scope.id, {code: "document.getElementById('volume-slider').value -= 5"});
                break;
            case "listFW": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"next-button style-scope ytmusic-player-bar\")[0].click()"});
                //browser.tabs.executeScript(scope.id, {code: "player.playerApi_.nextVideo()"});
                break;
            case "listBW": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"previous-button style-scope ytmusic-player-bar\")[0].click()"});
                //browser.tabs.executeScript(scope.id, {code: "player.playerApi_.previousVideo()"});
                break;
            case "timeFW": // works finally
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].currentTime += 5"}); // gonna try
                break;
            case "timeBW": // see above
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByTagName('video')[0].currentTime -= 5"});
                break;
            case "multiUp": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"like style-scope ytmusic-like-button-renderer\")[0].click()"});
                break;
            case "multiDown": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"dislike style-scope ytmusic-like-button-renderer\")[0].click()"});
                break;
            case "multiL": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"repeat style-scope ytmusic-player-bar\")[0].click()"});
                break;
            case "multiR": // fine
                browser.tabs.executeScript(scope.id, {code: "document.getElementsByClassName(\"shuffle style-scope ytmusic-player-bar\")[0].click()"});
                break;            
            default:
                console.log("Invalid command in RequestEvent handler.")
                break;
        }
        return;
    }
    else
    {
        console.log("Invalid scope.")
    }
}



function onError(error) {
    console.log(`Error: ${error}`);
    return;
}