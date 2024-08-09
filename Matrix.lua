local sides = {"left", "right", "back", "top", "bottom", "front"}
local monitor = nil
 
-- Find the monitor
for _, side in ipairs(sides) do
    if peripheral.isPresent(side) and peripheral.getType(side) == "monitor" then
        monitor = peripheral.wrap(side)
        break
    end
end
 
if not monitor then
    print("No monitor found on any side.")
    return
end
 
monitor.clear()
monitor.setTextScale(0.5) -- Adjust text scale to fit more characters
local width, height = monitor.getSize()
 
-- Characters to display: Uppercase, lowercase, numbers, and symbols
local chars = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
               "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", 
               "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", 
               "U", "V", "W", "X", "Y", "Z", 
               "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
               "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", 
               "u", "v", "w", "x", "y", "z", 
               "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+"}
 
-- Set the background color to black
monitor.setBackgroundColor(colors.black)
 
-- Initialize columns with random starting positions and delays
local columns = {}
for x = 1, width do
    columns[x] = {
        y = math.random(1, height), -- Start position
        delay = math.random(1, 5),  -- Delay between updates
        currentDelay = 0            -- Current delay counter
    }
end
 
while true do
    for x = 1, width do
        local column = columns[x]
        
        -- Check if the column should update
        if column.currentDelay >= column.delay then
            column.currentDelay = 0
            
            -- Move the column down
            local previousY = column.y
            if column.y < height then
                column.y = column.y + 1
            else
                column.y = 1 -- Reset to top
            end
            
            -- Draw the leading character in bright green (bold effect)
            monitor.setCursorPos(x, column.y)
            monitor.setTextColor(colors.lime) -- Brighter green for bold effect
            monitor.write(chars[math.random(1, #chars)])
            
            -- Gradually clear the trail behind the leading character
            for i = 1, 4 do
                local trailY = column.y - i
                if trailY < 1 then
                    trailY = height + trailY
                end
                monitor.setCursorPos(x, trailY)
                if i == 4 then
                    monitor.write(" ") -- Clear the fourth character back
                else
                    monitor.setTextColor(colors.green) -- Normal green for trail
                    monitor.write(chars[math.random(1, #chars)])
                end
            end
        else
            column.currentDelay = column.currentDelay + 1
        end
    end
    
    sleep(0.05) -- Control the speed of the animation
end