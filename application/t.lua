dofile('ensureDb.lc')

print('a',node.heap())
db = sqlite3.open('db.sqlite3')
print('b', node.heap())

db:exec[[
INSERT INTO logs VALUES (NULL, 'Hello, World', 123, 123);
]]

print('c', node.heap())


db:close()

db = sqlite3.open('db.sqlite3')

print(aaa)

for row in db:nrows("SELECT * FROM logs LIMIT 10") do
    print(sjson.encode(row))
  print(row.id, row.sensorId, row.value)
end
