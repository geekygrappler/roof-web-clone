statable = LineItem.first
value = 30
Stat.get(:average_rate, {statable: statable})


statable = LineItem.first
value = 500
Stat.set(:last_rate, {value: value, statable: statable})
Stat.get(:last_rate, {statable: statable})