async function GoSound(time)
{
    console.log("-----------------------------");
    console.log("LEGACY CODE. DO NOT USE.");
    console.log("-----------------------------");
    return;
    if (time >= glTime-100 && time <= glTime+100)
    {
        console.log("WITHIN SAME TIME - Doubleclick preventor.");
        return;
    }    
    c = 0;
    browser.tabs.query({audible: true}).then(function(tabs)
    {
        for(let tab of tabs)
        {
            console.log(tab.id + " = ID.");
            if (tab.url.includes("music.youtube.com")){browser.tabs.executeScript(tab.id, ytMusic); c++; return; }
            else if (tab.url.includes("youtube.com")){browser.tabs.executeScript(tab.id, ytNormal); c++; return; }
        }
    }, onError);

    await sleep(50);

    if (c >= 1)
    {
        console.log("Toggled sound in a window, no longer looking for active tabs.");
        return;
    }

    c=0;
    browser.tabs.query({active: true}).then(function(tabs)
    {
        console.log("No active tabs playing sound, looking at active tab...")
        for(let tab of tabs)
        {
            if (tab.url.includes("music.youtube.com")){browser.tabs.executeScript(tab.id, ytMusic); c++; return;}
            else if (tab.url.includes("youtube.com")){browser.tabs.executeScript(tab.id, ytNormal); c++; return;}
        }
    },onError)

    await sleep(50);
    
    if (c >= 1)
    {
        console.log("Now looking for music page.");
        return;
    }

    browser.tabs.query({url: "*://music.youtube.com/*"}).then(function(tabs)
    {
        console.log("No active tabs playing sound, not on youtube, playing Youtube Music.")
        for(let tab of tabs)
        {
            browser.tabs.executeScript(tab.id, ytMusic); 
            return;
        }
    },onError)

    function onError(error) {
        console.log(`Error: ${error}`);
    }
    return;
}