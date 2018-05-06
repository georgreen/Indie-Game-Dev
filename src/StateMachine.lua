StateMachine = class{}


function StateMachine:init(states)
  self.empty = {
    render = function() end,
    update = function() end,
    enter = function() end,
    exit = function() end
  }
  self.states = states or {}
  self.currentState = self.empty
end


function StateMachine:change(stateName, enterParams)
  assert(self.states[stateName])
  self.currentState:exit()
  self.currentState = self.states[stateName]()
  self.currentState:enter(enterParams)
end


function StateMachine:update(dt)
  self.currentState:update(dt)
end


function StateMachine:render()
  self.currentState:render()
end
