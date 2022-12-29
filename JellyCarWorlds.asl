state("JellyCar Worlds") {}

startup
{
    settings.Add("split_levelexit", true, "Split on each level exit");
    settings.Add("split_worldexit", true, "Split on each world exit");

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var ujc = mono["UtilsJellyCar"];
        var lc = mono["LevelCommon"];

        vars.Helper["ActiveLevelName"] = ujc.MakeString("ActiveLevelName");
        vars.Helper["ActiveLevelType"] = ujc.Make<int>("ActiveLevelType");
        vars.Helper["LevelIsComplete"] = lc.Make<bool>("_active", 0xF4);
        current.LevelIsComplete = false;

        return true;
    });
}

update
{
    current.SceneName = vars.Helper.Scenes.Active.Name ?? old.SceneName;
}

start
{
    if (current.SceneName == "game" && old.SceneName == "newgame")
    {
        vars.Log("Start");
        return true;
    }
}

reset
{
    if (current.SceneName == "newgame" && old.SceneName == "menus")
    {
        vars.Log("Reset");
        return true;
    }
}

split
{
    if (current.LevelIsComplete && !old.LevelIsComplete)
    {
        if (settings["split_worldexit"] && current.ActiveLevelType == 0)
        {
            return true;
        }

        if (settings["split_levelexit"] && current.ActiveLevelType == 1)
        {
            return true;
        }
    }
}
