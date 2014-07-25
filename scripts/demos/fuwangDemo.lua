local fuwangDemo = class("fuwangDemo", game.DragonBonesDemo)
function fuwangDemo:ctor(...)
	self.mainTitle = "fuwang"
	self:_createDB()
	fuwangDemo.super.ctor(self, ...)
end
function fuwangDemo:_createDB()
	local manager = CCDBManager:getInstance()
	--[[
	display.loadDragonBonesDataFiles("fuwang/skeleton.xml", 
		"fuwang/texture.xml", "fuwang",
		function(evt)
			print("async donw")
			self._db = display.newDragonBones({
					dragonBonesName="fuwang",
					armatureName="fuwang",
				})
			:addTo(self)
			:pos(display.cx, 100)
			:addMovementScriptListener(handler(self, self._onMovement))
		end
		)
	--]]
	print("开始加载", self)
	self._db = display.newDragonBones({
			skeleton="fuwang/skeleton.xml",
			texture="fuwang/texture.xml",
			dragonBonesName="fuwang",
			armatureName="fuwang",
			aniName="",
		})
	
	print("加载结果", self._db)

	self._db:addTo(self, 10)
		:pos(display.cx,100)
		:addMovementScriptListener(handler(self, self._onMovement))


	
	self._db:gotoAndPlay("chuantai")

end
function fuwangDemo:_onMovement(evtType, movId)
	printf("DragonDemoEntry:_onMovement eventType:%s, movId:%s", evtType, movId)
	if evtType == CCDragonBonesExtend.EVENTS.START then
		print("This is the first start!")
	end
	print("getLastAnimationName:", self._db:getAnimation():getLastAnimationName())
end

return fuwangDemo
