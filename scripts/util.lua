function getVS()
	return CCDirector:sharedDirector():getVisibleSize()
end
function createSequence(act)
	local arr = CCArray:create()
	for k, v in ipairs(act) do
		arr:addObject(v)
	end
	return CCSequence:create(arr)
end