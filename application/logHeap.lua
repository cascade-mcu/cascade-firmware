function logHeap()
    require('logSensor')
    logSensor('Heap', node.heap())
    package.loaded['logSensor'] = nil
    logSensor = nil
end
