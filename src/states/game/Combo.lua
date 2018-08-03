Combo = class("Combo")
Combo.static.BASE_MULTIPLIER = 1
Combo.static.INCREASE = 0.5

function Combo:initialize()
  self.multiplier = Combo.BASE_MULTIPLIER
end

function Combo:multiply(score) 
  self:update(score)
  if score > 0 then 
    return score * self.multiplier
  else
    return score
  end
end

function Combo:update(score)
  if score >= Level.MAX_SCORE * 0.5 then
    self.multiplier = self.multiplier + Combo.INCREASE
  else
    self.multiplier = Combo.BASE_MULTIPLIER
  end  
end