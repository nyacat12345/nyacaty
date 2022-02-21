function Shoot()
    
    local rng = Random.new()
    
    local laser = Instance.new("Part")
    laser.Name = "Laser"
    laser.TopSurface = Enum.SurfaceType.Smooth
    laser.BottomSurface = Enum.SurfaceType.Smooth
    laser.Size = Vector3.new(0.2, 0.2, 0.2)
    laser.Color = Color3.new(rng:NextNumber(), rng:NextNumber(), rng:NextNumber())
    laser.Anchored = true
    laser.CanCollide = false
    laser.Locked = true
    laser.CFrame = script.Parent.CFrame
    laser.Parent = workspace
    
    local maxDistance = 200
    local curDistance = 0
    
    local stepDistance = 4
    local stepWait = 0
    
    local currentPos = script.Parent.Position
    local currentNormal = script.Parent.CFrame.LookVector
    
    local function Step(overrideDistance)
        
        local params = RaycastParams.new()
        local direction = currentNormal * (overrideDistance or stepDistance)
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {script.Parent}
        local result = workspace:Raycast(currentPos, direction)
        local pos
        
        if result then
            pos = result.Position
        else
            pos = currentPos + direction
        end


        laser.Size = Vector3.new(0.4, 0.4, (pos - currentPos).Magnitude)
        laser.CFrame = CFrame.new(currentPos:Lerp(pos, 0.5), pos)
        
        local oldPos = currentPos
        currentPos = pos
        
        if result then

            local norm = result.Normal
            local reflect = (currentNormal - (2 * currentNormal:Dot(norm) * norm))
            currentNormal = reflect
            Step(stepDistance - (pos - oldPos).Magnitude)
            return
        end
        
        curDistance = (curDistance + (pos - oldPos).Magnitude)
        

        if curDistance > (maxDistance - 75) then
            local d = (curDistance - (maxDistance - 75)) / 75
            laser.Transparency = d
        end
        

        if curDistance < maxDistance then
            task.wait(stepWait)
            Step()
        end
    end
    
    Step()
    
    laser:Destroy()
    
end
