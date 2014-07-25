local DemoScene = class("DemoScene", function()
	return display.newScene("DemoScene") 
	end)

--左侧显示从文件中加载动画
--可以选择不同的人物来显是
--下面是左右按钮 切换不同的人物
--右侧是动作列表 表示从文件中获得所有动作

--文件夹命名规范 anixx  xx时候动画id  1 --一直向后编号即可
function DemoScene:ctor()
	local images = {
		normal="b1.png",
		pressed = "b2.png",

	}
	local last = cc.ui.UIPushButton.new(images)
		:addTo(self)
		:pos(240-100, 50)
		:addButtonClickedEventListener(handler(self, self.onLast))

	local images = {
		normal = "f1.png",
		pressed = "f2.png",
	}

	local nextAni = cc.ui.UIPushButton.new(images)
	:addTo(self)
	:pos(240+100, 50)
	:addButtonClickedEventListener(handler(self, self.onNext))

	self.curAni = 1
	self.title = ui.newTTFLabelWithOutline({text="当前动画"..self.curAni, size=30, color=ccc3(10, 240, 20), textAlign=ui.TEXT_ALIGN_CENTER, textValign=ui.TEXT_VALIGN_CENTER})
	self.title:addTo(self, 100):pos(display.cx, display.height-50)
	self.title:setAnchorPoint(ccp(0.5, 0.5))
	self:loadAni()
end

function DemoScene:onLast()
	self.curAni = self.curAni-1
	local res = self:loadAni()
	if not res then
		self.curAni = self.curAni+1	
	end

end
function DemoScene:onNext()
	self.curAni = self.curAni+1
	if not self:loadAni() then
		self.curAni = self.curAni-1
	end
end


function DemoScene:loadAni()
	if self._db ~= nil then
		self._db:removeFromParent()
		self._db = nil
	end

	local skeName = "ani"..self.curAni.."/skeleton.xml"
	local texName = "ani"..self.curAni.."/texture.xml"
	local fd = CCFileUtils:sharedFileUtils():getFileData(skeName)
	
	--print(fd)
	--加载动画失败
	if fd == nil then
		local lab = ui.newTTFLabelWithOutline({text="加载失败"..self.curAni, size=50, color=ccc3(240, 50, 50), textAlign=kCCTextAlignmentCenter})
		lab:addTo(self):pos(140, 300)
		lab:setAnchorPoint(ccp(0.5, 0.5))
		
		lab:setZOrder(1000)
		lab:runAction(createSequence({CCDelayTime:create(5), CCCallFunc:create(
			function() 
				lab:removeFromParent()
				end)}
		))

		return false
	end

	--动画名字
	local i, j, dname = string.find(fd, 'name="(.-)"')

	local i, j, aname = string.find(fd, 'armature name="(.-)"')
	print(dname, aname)
	self._db = display.newDragonBones({
			skeleton=skeName,
			texture=texName,
			dragonBonesName=dname,
			armatureName=aname,
			aniName="",
		})
	print("加载动画", self._db)

	if self._db ~= nil then
		self._db:addTo(self, 10)
			:pos(display.cx, display.cy)
			:addMovementScriptListener(handler(self, self._onMovement))

		local allAnim = {}
		local init = 1
		while true do
			local i, j, aniName = string.find(fd, 'animation name="(.-)"', init)
			print("播放动画", aniName)
			if i == nil then
				break
			else
				table.insert(allAnim, aniName)
				init = j
			end
		end
		print("所有", json.encode(allAnim))

		--右侧显示文字按钮
		local vs = getVS()
		local initX = vs.width-70
		local initY = vs.height-50
		local offY = 60

		for k, v in ipairs(allAnim) do
			local images = {
				normal = "r1.png",
				pressed = "r2.png",
			}

			--播放特定动画
			local but = cc.ui.UIPushButton.new(images)
				:onButtonClicked(function()
					self._db:gotoAndPlay(v)
				end)
				:addTo(self)
				:pos(initX, initY-(k-1)*offY)

			local w = ui.newTTFLabelWithOutline({text=v, size=30, color=ccc3(240, 120, 10), textAlign=kCCTextAlignmentCenter})
			w:setAnchorPoint(ccp(0.5, 0.5))
			
			--but:setButtonLabel(w)
			w:addTo(but)
		end


		self._db:gotoAndPlay(allAnim[1])
	end
	self.title:setString("当前动画"..self.curAni)
	return true
end

function DemoScene:_onMovement(evtType, movId)
end



return DemoScene