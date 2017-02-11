function love.load()
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize( 5 )
	drawing = {}
	mouseX = 0
	mouseY = 0
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	love.graphics.setLineWidth(3)
	angle = 0
	scale = love.graphics.newImage("Graphics/UI/Scale.png")
	scissors1 = love.graphics.newImage("Graphics/UI/Scissors.png")
    scissors2 = love.graphics.newImage("Graphics/UI/Scissors2.png")
	player = {}
	player.score = 0
	lastMouseX = 0
	lastMouseY = 0
    frameCounter = 0;
end

function love.update(dt)
	-- exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	lastMouseX = mouseX
	lastMouseY = mouseY
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if love.mouse.isDown(1) and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY)) then
		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
		-- print('inserted')

		for i = 1, #drawing-20 do
			if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
				if isIntersect(drawing[i].x, drawing[i].y, drawing[i].lastX, drawing[i].lastY, mouseX, mouseY, lastMouseX, lastMouseY, true, true) then
					print('CUT')
				end
			end
		end
	end
end

function love.draw()	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.draw(scale, 50, height - 100)
	for i,v in ipairs(drawing) do
		love.graphics.line(v.x, v.y, v.lastX, v.lastY)
	end
	if ((lastMouseY ~= mouseY or lastMouseX ~= mouseX) and drawing[#drawing - 10] ~= nil and love.mouse.isDown(1)) then
		angle = math.angle(mouseX, mouseY, drawing[#drawing - 5].x, drawing[#drawing - 5].y)
	end
    love.graphics.setColor(255, 255, 255, 255)
    if (frameCounter < 10) then
	love.graphics.draw(scissors1, love.mouse.getX(), love.mouse.getY(), 
		angle, 1, 1, scissors1:getWidth()/2, scissors1:getHeight()/2) 
        if (love.mouse.isDown(1)) then
        frameCounter = frameCounter + 1
        end else
        love.graphics.draw(scissors2, love.mouse.getX(), love.mouse.getY(), 
		angle, 1, 1, scissors2:getWidth()/2, scissors2:getHeight()/2)
        if (love.mouse.isDown(1)) then
        frameCounter = frameCounter + 1
        if (frameCounter == 20) then
            frameCounter = 0
             end
         end
    end
end

function math.angle(x1,y1, x2,y2) 
	return math.atan2(y2-y1, x2-x1) 
end

-- function hasValue(table, val)
--     for i,v in ipairs (table) do
--         if v == val then
--             return true
--         end
--     end
--     return false
-- end

-- Checks if two lines intersect (or line segments if seg is true)
-- Lines are given as four numbers (two coordinates)
function isIntersect(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
	local det,x,y = a1*b2 - a2*b1
	if det==0 then return false, "The lines are parallel." end
	x,y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
	if seg1 or seg2 then
		local min,max = math.min, math.max
		if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
			seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
    intersection = {x, y}
	return true --x,y
end
