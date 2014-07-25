
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

package.path = package.path
	 --.. ";d:/cocos2dx/quick/?.lua"
	 .. ";/Users/zrong/cocos2dx/quick/?.lua"


local function main()
	require("util")
	require("game")
	game.startup()
end

xpcall(main, __G__TRACKBACK__)

